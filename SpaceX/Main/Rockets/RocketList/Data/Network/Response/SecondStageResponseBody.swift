import Foundation
struct SecondStageResponseBody: Codable, Hashable {
    let thrust: ThrustResponseBody
    let payloads: PayloadResponseBody
    let reusable: Bool
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSec: Double?

    enum CodingKeys: String, CodingKey {
        case thrust
        case payloads
        case reusable
        case engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSec = "burn_time_sec"
    }
}
