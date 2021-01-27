//
//  RocketDetailsRepo.swift
//  SpaceX
//
//  Created by Ravisankar on 26/01/21.
//

import Foundation
import RxSwift

final class RocketDetailsRepo: RocketDetailsRepoProtocol {
    
    let apiClient: ApiService
    
    init(apiClient: ApiService = ApiService()) {
        self.apiClient = apiClient
    }
    
    func getRocketDetails(id: String) -> Observable<RocketDetails>  {
        
        return getRocketDetailsFromBackend(id: id).map { responseModel in
            
            let imageURL = URL(string: responseModel.flickrImages?.first ?? "")
            let wikipediaURL = URL(string: responseModel.wikipedia ?? "")
            return RocketDetails(name: responseModel.name ?? "",
                            details: responseModel.welcomeDescription ?? "",
                            imageUrl: imageURL,
                            wikipediaURL: wikipediaURL)
        }
    }
    
    private func getRocketDetailsFromBackend(id: String) -> Observable<RocketResponseModel> {
        let endPoint = EndPoint(path: "/v4/rockets/\(id)")
        return apiClient.request(with: endPoint)
    }
}
