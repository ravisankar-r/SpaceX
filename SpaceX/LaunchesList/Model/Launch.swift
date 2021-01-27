//
//  Launch.swift
//  SpaceX
//
//  Created by Ravisankar on 27/01/21.
//

import Foundation

struct LaunchList {
    
    var items: [Launch]
    var hasNextPage = true
    var page = 1
}

struct Launch {
    
    let name: String
    let description: String
    let launchDate: String
    let rocketId: String
    var imageURL: URL?
    var upcoming: Bool
}
