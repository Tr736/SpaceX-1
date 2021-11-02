import Foundation
struct MassResponseBody: Codable, Hashable {
    let kg: Int
    let lb: Int

    enum CodingKeys: String, CodingKey {
        case kg
        case lb
    }
}
