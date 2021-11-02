import Foundation
struct LandingLegsResponseBody: Codable, Hashable {
    let number: Int
    let material: String?

    enum CodingKeys: String, CodingKey {
        case number
        case material
    }
}
