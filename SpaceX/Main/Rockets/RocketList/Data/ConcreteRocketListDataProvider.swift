import Foundation
import PromiseKit

public protocol RocketListDataProvider {
    func fetchRocketList() -> Promise<[RocketListResponseBody]>
}

public class ConcreteRocketListDataProvider: RocketListDataProvider {
    private let api: SpaceXAPI

    public init(api: SpaceXAPI) {
        self.api = api
    }

    public func fetchRocketList() -> Promise<[RocketListResponseBody]> {
        let request = RocketListRequest()
        return api.execute(endpoint: request)
    }
}
