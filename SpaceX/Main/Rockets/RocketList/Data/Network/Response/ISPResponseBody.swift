import Foundation
struct ISPResponseBody: Codable, Hashable {
    let seaLevel: Double
    let vacuum: Double

    enum CodingKeys: String, CodingKey {
        case seaLevel = "sea_level"
        case vacuum
    }
}
