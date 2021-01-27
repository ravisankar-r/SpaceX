//
//  Constants.swift
//  SpaceX
//
//  Created by Ravisankar on 26/01/21.
//

import Foundation

enum Constants {
    
    struct Network {
        static let scheme = "https"
        static let baseUrlHost = "api.spacexdata.com"
    }
    
    struct ApiPaths {
        static let launchesQuery = "/v4/launches/query"
    }
}
