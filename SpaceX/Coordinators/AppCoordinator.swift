//
//  AppCoordinator.swift
//  SpaceX
//
//  Created by Ravisankar on 27/01/21.
//

import UIKit
import RxSwift
import SafariServices

class AppCoordinator {
    
    var navigationController: UINavigationController
    let disposeBag = DisposeBag()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        
        let viewModel = LaunchesViewModel()
        
        viewModel.selectedRocket.subscribe(onNext: { [unowned self] rocketId in
            
            self.didSelect(rocketId)
        }).disposed(by: disposeBag)
        
        let storyBoard = UIStoryboard.storyboard(.Launches)
        let viewController = storyBoard.instantiateViewController(
            identifier: LaunchListViewController.viewControllerIdentifier,
                    creator: { coder in
                        LaunchListViewController(coder: coder,
                                                 viewModel: viewModel,
                                                 coordinator: self)
                    }
                ) 

        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func didSelect(_ rocketId: String) {
        
        let viewModel = RocketDetailsViewModel(rocketId: rocketId)
        viewModel.wikiURLObserver.subscribe(onNext: { url in
            
            self.openURL(url)
        }).disposed(by: disposeBag)
        
        let storyBoard = UIStoryboard.storyboard(.Launches)
        let viewController = storyBoard.instantiateViewController(identifier: RocketDetailViewController.viewControllerIdentifier, creator: { coder in
            
            return RocketDetailViewController(coder: coder, viewModel: viewModel)
        })
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func openURL(_ url: URL) {
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.modalPresentationStyle = .overCurrentContext
        navigationController.visibleViewController?.present(vc, animated: true)
    }
}
