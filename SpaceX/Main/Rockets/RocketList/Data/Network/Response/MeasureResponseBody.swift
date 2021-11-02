import Foundation
struct LengthResponseBody: Codable, Hashable {
    let meters: Double?
    let feet: Double?

    enum CodingKeys: String, CodingKey {
        case meters
        case feet
    }
}
