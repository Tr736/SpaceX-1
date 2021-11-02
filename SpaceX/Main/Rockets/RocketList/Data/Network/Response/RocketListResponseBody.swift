import Foundation
import UIKit

public struct RocketListResponseBody: Codable, Hashable {
    let height: LengthResponseBody
    let diameter: LengthResponseBody
    let mass: LengthResponseBody
    let firstStage: FirstStageResponseBody
    let secondStage: SecondStageResponseBody?
    let engines: EnginesResponseBody
    let landingLegs: LandingLegsResponseBody
    let payloadWeights: [PayloadWeightsResponseBody]
    let imagesURL: [URL]
    let name: String
    let type: String
    let active: Bool
    let stages: Int
    let boosters: Int
    let costPerLaunch: Int
    let successRatePercentage: Double
    let firstFlight: String
    let country: String
    let company: String
    let wikipedia: URL
    let description: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case height
        case diameter
        case mass
        case firstStage = "first_stage"
        case secondStage = "second_stage"
        case engines
        case landingLegs = "landing_legs"
        case payloadWeights = "payload_weights"
        case imagesURL = "flickr_images"
        case name
        case type
        case active
        case stages
        case boosters
        case costPerLaunch = "cost_per_launch"
        case successRatePercentage = "success_rate_pct"
        case firstFlight = "first_flight"
        case country
        case company
        case wikipedia
        case description
        case id
    }
}
