import Foundation
import SpaceX
import PromiseKit
public class SpaceXAPIMock: SpaceXAPI {

    public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy?

    public var previousRequest: APIEndpointObject?

    public var executeReturnData: Data?

    public init() {}

    public func execute<T: APIEndpoint>(endpoint: T) -> Promise<T.ResponseBody> {
        previousRequest = endpoint
        if let data = executeReturnData {
            do {
                let jsonDecoder = JSONDecoder()
                let model = try jsonDecoder.decode(T.ResponseBody.self, from: data)
                return .value(model)
            } catch {
                return Promise(error: error)
            }
        } else {
            return Promise(error: SpaceXAPIMockError.isAMock)
        }
    }

    public func executeIncludingRawData<T>(endpoint: T) -> Promise<(T.ResponseBody, Data)> where T: APIEndpoint {
        execute(endpoint: endpoint).map {
            ($0, self.executeReturnData!)
        }
    }

    public func executeRaw<T>(endpoint: T) -> Promise<(data: Data, response: URLResponse)> where T: APIEndpoint {
        previousRequest = endpoint
        if let data = executeReturnData {
            return .value((data, URLResponse()))
        }
        return Promise(error: SpaceXAPIMockError.isAMock)
    }
}

private enum SpaceXAPIMockError: Error {
    case isAMock
}
