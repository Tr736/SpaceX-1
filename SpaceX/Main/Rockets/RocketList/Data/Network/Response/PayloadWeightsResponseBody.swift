import Foundation

struct PayloadWeightsResponseBody: Codable, Hashable {

    let id: String
    let name: String
    let kg: Int
    let lb: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case kg
        case lb
    }
}
