import Foundation
struct PayloadResponseBody: Codable, Hashable {
    let compositeFairing: CompositeFairingResponseBody
    let optionOne: String

    enum CodingKeys: String, CodingKey {
        case compositeFairing = "composite_fairing"
        case optionOne = "option_1"
    }
}
