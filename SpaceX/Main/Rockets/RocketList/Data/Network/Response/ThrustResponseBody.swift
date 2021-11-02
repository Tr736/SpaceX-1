import Foundation
struct ThrustResponseBody: Codable, Hashable {
    let kN: Int
    let lbf: Int
    
    enum CodingKeys: String, CodingKey {
        case kN
        case lbf
    }
}
