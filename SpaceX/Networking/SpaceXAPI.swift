import Foundation
import PromiseKit
/// PromiseKit is the ONLY exception to where a class can depend on it directly

// TODO: Replace PromiseKit with Combine
public protocol SpaceXAPI {
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? { get set }
    func execute<T: APIEndpoint>(endpoint: T) -> Promise<T.ResponseBody>
    func executeRaw<T: APIEndpoint>(endpoint: T) -> Promise<(data: Data, response: URLResponse)>
    func executeIncludingRawData<T>(endpoint: T) -> Promise<(T.ResponseBody, Data)> where T: APIEndpoint
}

public protocol APIEndpointObject {
    var isAuthenticated: Bool { get }
    var method: RequestMethod { get }
    var params: RequestParams { get }
    var path: String { get }
}

public protocol APIEndpoint: APIEndpointObject {
    associatedtype ResponseBody: Decodable

    var isAuthenticated: Bool { get }
    var method: RequestMethod { get }
    var params: RequestParams { get }
    var path: String { get }
}

public enum RequestParams {
    case json(Encodable)
    case form([String: String])
    case query([String: String])
    case none
}

public enum RequestMethod: String {
    case get
    case post
    case put
    case delete
}

public struct APIErrorResponse: Codable, Equatable, LocalizedError {

    public let code: Int
    public let message: String

    public init(code: Int, message: String) {
        self.code = code
        self.message = message
    }

}

public enum APIError: Error, LocalizedError {
    case failed
    case invalidUrl
    case unauthorized
    case receivedError(APIErrorResponse, responseData: Data)

    public var recoverySuggestion: String? {
        switch self {
        case let .receivedError(apiError, _):
            return apiError.recoverySuggestion
        default:
            return nil
        }
    }
}
