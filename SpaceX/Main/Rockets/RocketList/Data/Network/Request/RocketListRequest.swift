import Foundation
struct RocketListRequest: APIEndpoint {
    typealias ResponseBody = [RocketListResponseBody]
    var isAuthenticated: Bool = false
    var method: RequestMethod = .get
    var params: RequestParams
    var path: String

    init() {
        self.params = .none
        self.path = "/v4/rockets"
    }
}
