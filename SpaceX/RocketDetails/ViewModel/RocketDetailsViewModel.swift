//
//  RocketDetailsViewModel.swift
//  SpaceX
//
//  Created by Ravisankar on 27/01/21.
//

import Foundation
import RxSwift
import SDWebImage

final class RocketDetailsViewModel {
    
    let buttonTapObserver = PublishSubject<Void>()
    let wikiURLObserver = PublishSubject<URL>()
    let titleText: PublishSubject<String?> = PublishSubject()
    let descriptionText: PublishSubject<String?> = PublishSubject()
    let imageUrl: PublishSubject<URL?> = PublishSubject()
    let viewDidLoad: PublishSubject<Void> = PublishSubject()
    
    private let repo: RocketDetailsRepoProtocol
    private let disposeBag: DisposeBag
    private let rocketId: String
    private var rocket: RocketDetails?
    
    init(repo: RocketDetailsRepoProtocol = RocketDetailsRepo(),
         rocketId: String) {
        
        self.rocketId = rocketId
        self.repo = repo
        self.disposeBag = DisposeBag()
        
        viewDidLoad.subscribe(onNext: { [weak self] _ in
            
            self?.loadRocketDetails()
        }).disposed(by: disposeBag)
        
        buttonTapObserver.subscribe(onNext: { _ in
            
            guard let rocket = self.rocket,
                  let wikiURL = rocket.wikipediaURL else {
                return
            }
            self.wikiURLObserver.onNext(wikiURL)
        }).disposed(by: disposeBag)
    }
    
    func loadRocketDetails()  {
        
        repo.getRocketDetails(id: rocketId).subscribe(onNext: { [weak self] rocket in
            
            self?.rocket = rocket
            self?.titleText.onNext(rocket.name)
            self?.descriptionText.onNext(rocket.details)
            self?.imageUrl.onNext(rocket.imageUrl)
        }).disposed(by: disposeBag)
    }
}
