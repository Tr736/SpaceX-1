import Foundation
/// Environment is a class that returns URL's and possibly Tokens for 3rd party frameworks. It should support Dev/Staging/Product.
class Environment: NSObject {
    static let baseUrl: URL = URL(string: "https://api.spacexdata.com")!
}
