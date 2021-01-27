//
//  LaunchesRepo.swift
//  SpaceX
//
//  Created by Ravisankar on 26/01/21.
//

import Foundation
import RxSwift

protocol LaunchesRepoProtocol {
    
    func getLaunches(withFilter filter: Filter) -> Observable<[Launch]>
}

final class LaunchesRepo {
    
    let apiClient: ApiService
    var launchList = LaunchList(items: [])
    
    init(apiClient: ApiService = ApiService()) {
        self.apiClient = apiClient
    }
    
    private func getLaunchesFromBackend(with filter: Filter) -> Observable<LaunchResponseModel> {
        
        let requestBody: [String: Any] = ["options": ["page": launchList.page,
                                                      "sort": ["date_utc":"desc"]],
                                          "query": ["date_utc":
                                                        ["$gte": "2018-06-22T00:00:00.000Z"]]]
        
        let endPoint = EndPoint(path: Constants.ApiPaths.launchesQuery,
                                httpMethod: .post(body: requestBody),
                                headers: nil)
        return apiClient.request(with: endPoint)
    }
    
    private func convertToLaunchModel(_ model: LaunchItem) -> Launch {
        
        let imageUrlString = model.links?.patch?.large ?? ""
        
        return Launch(name: model.name,
                      description: model.details ?? "",
                      launchDate: model.dateLocal,
                      rocketId: model.rocket,
                      imageURL: URL(string: imageUrlString),
                      upcoming: model.upcoming ?? false)
    }
    
    private func convertToLaunchList(_ model: LaunchResponseModel) -> LaunchList {
        
        launchList.page += 1
        launchList.hasNextPage = model.hasNextPage ?? false
        launchList.items.append(contentsOf: model.docs.map(convertToLaunchModel))
        return launchList
    }
}

extension LaunchesRepo: LaunchesRepoProtocol {
    
    func getLaunches(withFilter filter: Filter) -> Observable<[Launch]> {
        
        guard launchList.hasNextPage else {
            return Observable.just(launchList.items)
        }
        
        return getLaunchesFromBackend(with: filter)
            .map { [weak self] responseModel in
                return (self?.convertToLaunchList(responseModel).items ?? []) }
    }

}
