//
//  RocketDetailsProtocols.swift
//  SpaceX
//
//  Created by Ravisankar on 27/01/21.
//

import Foundation
import RxSwift

protocol RocketDetailsRepoProtocol {
    
    func getRocketDetails(id: String) -> Observable<RocketDetails>
}
