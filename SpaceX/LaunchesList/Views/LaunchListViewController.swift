//
//  LaunchListViewController.swift
//  SpaceX
//
//  Created by Ravisankar on 25/01/21.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

final class LaunchListViewController: UIViewController {
    
    static let startLoadingOffset: CGFloat = 20.0
    
    static func isNearTheBottomEdge(contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
        return contentOffset.y + tableView.frame.size.height + startLoadingOffset > tableView.contentSize.height
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var filterControl: UISegmentedControl!
    
    private weak var coordinator: AppCoordinator?
    private var viewModel: LaunchesViewModel
    private let disposeBag = DisposeBag()
    
    init?(coder: NSCoder,
          viewModel: LaunchesViewModel,
          coordinator: AppCoordinator) {
        
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        setupBindings()
        viewModel.viewDidLoad.onNext(())
    }
    
    private func configView() {
        
        title = "SpaceX Launches"
        view.backgroundColor = UIColor(named: "background")
        tableView.tableFooterView = UIView()
    }
    
    private func setupBindings() {
        
        viewModel.launchItems
            .bind(to: tableView.rx.items(cellIdentifier: LaunchTableViewCell.identifier,
                                         cellType: LaunchTableViewCell.self)) { (_, item, cell) in
                
                cell.configure(with: item)
            }.disposed(by: disposeBag)
        
        
        tableView.rx
            .modelSelected(Launch.self)
            .bind(to: viewModel.selectedLaunch)
            .disposed(by: disposeBag)
        
        tableView.rx
            .contentOffset
            .flatMap { offset in
                
                self.tableView
                    .isNearBottomEdge(edgeOffset: 20.0) ? Observable.just(()) : Observable.empty()
            }.bind(to: viewModel.loadNextPageTrigger)
            .disposed(by: disposeBag)
        
        filterControl.rx.selectedSegmentIndex.bind(to: viewModel.selectedIndex).disposed(by: disposeBag)
    }
}
