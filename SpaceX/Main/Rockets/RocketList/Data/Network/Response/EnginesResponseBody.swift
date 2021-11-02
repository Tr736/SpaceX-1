import Foundation

struct EnginesResponseBody: Codable, Hashable {
    let isp: ISPResponseBody
    let thrustSeaLevel: ThrustResponseBody
    let thrustVacuum: ThrustResponseBody
    let number: Int
    let type: String
    let version: String
    let layout: String?
    let engineLossMax: Double?
    let propellantOne: String
    let propellantTwo: String
    let thrustToWeight: Double

    enum CodingKeys: String, CodingKey {
        case isp
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
        case number
        case type
        case version
        case layout
        case engineLossMax = "engine_loss_max"
        case propellantOne = "propellant_1"
        case propellantTwo = "propellant_2"
        case thrustToWeight = "thrust_to_weight"
    }
}
