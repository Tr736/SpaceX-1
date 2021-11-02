import Foundation
import os.log
import PromiseKit

protocol RequestSigner {
    static func urlRequest(bySigning: NSMutableURLRequest) -> NSMutableURLRequest
}

class ConcreteSpaceXAPI: SpaceXAPI {

    private enum Headers {
        static let authToken = "auth_token"
        static let contentType = "Content-Type"
        static let contentTypeJson = "application/json"
        static let contentTypeFormEncoded = "application/x-www-form-urlencoded"
    }

    private enum ParameterKeys {
        static let platform = "platform"
        static let environment = "app_env"
        static let error = "error"
        static let message = "message"
    }

    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy?

    private let baseUrl: URL
    private let urlSession: URLSession
    private var authToken: String? {
        "NO_Auth_Required"
    }

    init(baseUrl: URL = Environment.baseUrl,
         urlSession: URLSession = URLSession.shared) {
        self.baseUrl = baseUrl
        self.urlSession = urlSession
    }

    func execute<T: APIEndpoint>(endpoint: T) -> Promise<T.ResponseBody> {
        let execution = firstly {
            executeRaw(endpoint: endpoint)
        }.map { data, _ -> T.ResponseBody in
            try self.decode(from: data)
        }

        execution.catch { error in
            if let error = error as? DecodingError {
                // TODO: Something with the error
                print(error.localizedDescription)
            }
        }

        return execution
    }

    func executeIncludingRawData<T>(endpoint: T) -> Promise<(T.ResponseBody, Data)> where T: APIEndpoint {
        firstly {
            executeRaw(endpoint: endpoint).map { data, _ in
                let decoded: T.ResponseBody = try self.decode(from: data)
                return (decoded, data)
            }
        }
    }

    private func decode<T>(from data: Data) throws -> T where T: Decodable {
        let decoder = JSONDecoder()
        if let dateDecodingStrategy = self.dateDecodingStrategy {
            decoder.dateDecodingStrategy = dateDecodingStrategy
        }
        return try decoder.decode(T.self, from: data)
    }

    func executeRaw<T: APIEndpoint>(endpoint: T) -> Promise<(data: Data, response: URLResponse)> {
        let category = OSLog.log(subsystem: "SpaceXAPI", category: String(describing: T.self))

        if endpoint.isAuthenticated, authToken == nil || authToken?.isEmpty ?? true {
            return .init(error: APIError.unauthorized)
        }

        let url: URL
        do {
            url = try buildUrl(for: endpoint)
        } catch {
            return Promise(error: error)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        switch endpoint.params {
        case let .json(body):
            request.setValue(Headers.contentTypeJson, forHTTPHeaderField: Headers.contentType)
            if endpoint.isAuthenticated,
               let authToken = authToken,
               let data = try? body.jsonData(),
               var json = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable: Any] {
                json[Headers.authToken] = authToken
                request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [])
            } else {
                request.httpBody = try? body.jsonData()
            }
        case var .form(body):
            if endpoint.isAuthenticated, let authToken = authToken {
                body[Headers.authToken] = authToken
            }

            request.setValue(Headers.contentTypeFormEncoded, forHTTPHeaderField: Headers.contentType)
            request.httpBody = FormEncoder().encode(body)
        case .query:
            break
        case .none:
            guard endpoint.isAuthenticated, endpoint.method != .get, let authToken = authToken else { break }
            request.setValue(Headers.contentTypeFormEncoded, forHTTPHeaderField: Headers.contentType)
            request.httpBody = FormEncoder().encode([Headers.authToken: authToken])
        }

        os_log("Making network request to %{PRIVATE}@", log: category, type: .info, url.absoluteString)


        return firstly {

            Promise { seal in
                urlSession.dataTask(with: request) { data, response, error in
                    if let error = error {
                        seal.reject(error)
                    }

                    if let data = data, let response = response {
                        seal.fulfill((data: data, response: response))
                    }
                }.resume()
            }

        }.get { data, response in
            os_log("Received response from %@ with status %{PUBLIC}d",
                   log: category, type: .info,
                   url.absoluteString, (response as? HTTPURLResponse)?.statusCode ?? 0)

            try self.validate(data: data, response: response)
        }
    }

    private func buildUrl<T: APIEndpoint>(for endpoint: T) throws -> URL {
        guard var components = URLComponents(string: endpoint.path) else {
            throw APIError.invalidUrl
        }

        if components.queryItems == nil {
            components.queryItems = []
        }

        if endpoint.method == .get || endpoint.method == .put, endpoint.isAuthenticated, let authToken = authToken {
            let queryParams = URLQueryItem(name: Headers.authToken, value: authToken)
            components.queryItems?.append(queryParams)
        }

        switch endpoint.params {
        case let .query(dict):
            if components.queryItems == nil {
                components.queryItems = []
            }
            for (key, value) in dict {
                components.queryItems?.append(URLQueryItem(name: key, value: value))
            }
        default: break
        }

        if components.queryItems?.isEmpty ?? false {
            components.queryItems = nil
        }

        guard let url = components.url(relativeTo: baseUrl) else {
            throw APIError.invalidUrl
        }

        return url
    }

    private func validate(data: Data, response: URLResponse) throws {
        if response.isSuccess {
            return
        }

       if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let code = jsonObject[ParameterKeys.error] as? Int,
                  let message = jsonObject[ParameterKeys.message] as? String {
            let response = APIErrorResponse(code: code, message: message)
            throw APIError.receivedError(response, responseData: data)
        } else {
            throw APIError.failed
        }
    }

}

extension APIEndpoint {
    var category: OSLog {
        OSLog.log(subsystem: "SpaceAPI", category: String(describing: Self.self))
    }
}

struct APIEndpointEmptyObject: Codable {}

private extension Encodable {
    func jsonData() throws -> Data {
        try JSONEncoder().encode(self)
    }
}

private extension URLResponse {
    var isSuccess: Bool {
        guard let response = self as? HTTPURLResponse else { return true }
        return response.statusCode >= 200 && response.statusCode < 400
    }
}

