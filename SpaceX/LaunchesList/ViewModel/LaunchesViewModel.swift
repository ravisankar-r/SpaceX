//
//  LaunchesViewModel.swift
//  SpaceX
//
//  Created by Ravisankar on 26/01/21.
//

import Foundation
import RxSwift
import RxRelay

enum Filter: Int {
    case all = 0
    case upcoming
}

final class LaunchesViewModel {
    
    let selectedIndex = PublishSubject<Int>()
    let selectedRocket = PublishSubject<String>()
    let selectedLaunch = PublishSubject<Launch>()
    let launchItems: PublishSubject<[Launch]> = PublishSubject()
    let loadNextPageTrigger: BehaviorSubject<Void> = BehaviorSubject(value: ())
    let viewDidLoad: PublishSubject<Void> = PublishSubject()

    private let repo: LaunchesRepoProtocol
    private let disposeBag: DisposeBag
    private var _launches: [Launch] = []
    
    private var selectedFilter = Filter.all {
        didSet{
            filterLaunches()
        }
    }
    
    init(repo: LaunchesRepoProtocol = LaunchesRepo()) {
        
        self.repo = repo
        self.disposeBag = DisposeBag()
        
        loadNextPageTrigger.asObservable()
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in

            self?.loadLaunches()
        }).disposed(by: disposeBag)
        
        viewDidLoad.subscribe(onNext: { [weak self] _ in
            
            self?.loadLaunches()
        }).disposed(by: disposeBag)
        
        selectedLaunch.subscribe(onNext: { [weak self] launch in
            
            self?.selectedRocket.onNext(launch.rocketId)
        }).disposed(by: disposeBag)
        
        selectedIndex
            .map{ Filter(rawValue: $0) }
            .subscribe(onNext: { [weak self] selection in
            
                if let selectedFilter = selection {
                    self?.selectedFilter = selectedFilter
                    }
        }).disposed(by: disposeBag)
       
    }
    
    func loadLaunches() {
        
        repo.getLaunches(withFilter: selectedFilter)
            .subscribe(onNext: { [weak self] launches in
            
                self?._launches = launches
            self?.filterLaunches()
        }, onError: { error in
            
            print(error)
        }).disposed(by: disposeBag)
    }
    
    func filterLaunches() {
        
        switch selectedFilter {
        case .all:
            launchItems.onNext(_launches)
        case .upcoming:
            launchItems.onNext(_launches.filter{ $0.upcoming })
        }
    }
}
