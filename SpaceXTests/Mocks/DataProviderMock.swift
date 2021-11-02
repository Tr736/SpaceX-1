import Foundation
import SpaceX
import PromiseKit
class RocketListDataProviderMock: RocketListDataProvider {
    let api: SpaceXAPI

    init(api: SpaceXAPI) {
        self.api = api
    }

    func fetchRocketList() -> Promise<[RocketListResponseBody]> {
        return .value([])
    }
}
