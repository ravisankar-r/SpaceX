//
//  RocketResponseModel.swift
//  SpaceX
//
//  Created by Ravisankar on 27/01/21.
//

import Foundation

// MARK: - Rocket
struct RocketResponseModel: Codable {
    var flickrImages: [String]?
    var name, type: String?
    var active: Bool?
    var firstFlight, country, company: String?
    var wikipedia: String?
    var welcomeDescription, id: String?

    enum CodingKeys: String, CodingKey {
        case flickrImages = "flickr_images"
        case name, type
        case firstFlight = "first_flight"
        case country, company, wikipedia
        case welcomeDescription = "description"
        case id
    }
}
