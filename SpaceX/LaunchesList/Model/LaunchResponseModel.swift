//
//  LaunchResponseModel.swift
//  SpaceX
//
//  Created by Ravisankar on 27/01/21.
//

import Foundation

// MARK: - LaunchResponseModel
struct LaunchResponseModel: Codable {
    var docs: [LaunchItem]
    var totalDocs, offset, limit, totalPages: Int?
    var page, pagingCounter: Int?
    var hasNextPage: Bool?
    var nextPage: Int?
}

// MARK: - Doc
struct LaunchItem: Codable {
    var links: Links?
    var rocket: String
    var details: String?
    var flightNumber: Int?
    var name: String
    var dateLocal: String
    var upcoming: Bool?
    var id: String?

    enum CodingKeys: String, CodingKey {
        case links
        case rocket, details
        case flightNumber = "flight_number"
        case name
        case dateLocal = "date_local"
        case upcoming, id
    }
}

// MARK: - Failure
struct Failure: Codable {
    var time: Int?
    var altitude: Int?
    var reason: String?
}

// MARK: - Links
struct Links: Codable {
    var patch: Patch?
}

// MARK: - Patch
struct Patch: Codable {
    var small, large: String?
}

