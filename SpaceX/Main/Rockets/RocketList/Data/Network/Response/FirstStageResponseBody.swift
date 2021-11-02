import Foundation
struct FirstStageResponseBody: Codable, Hashable {
    let thrustSeaLevel: ThrustResponseBody
    let thrustVacuum: ThrustResponseBody
    let reusable: Bool
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSec: Double?

    enum CodingKeys: String, CodingKey {
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
        case reusable
        case engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSec = "burn_time_sec"
    }
}
