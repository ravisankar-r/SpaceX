//
//  RocketDetailViewController.swift
//  SpaceX
//
//  Created by Ravisankar on 26/01/21.
//

import UIKit
import RxSwift
import RxCocoa

class RocketDetailViewController: UIViewController {
       
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var readMoreButton: UIButton!
   
    private let disposeBag = DisposeBag()
    private let viewModel: RocketDetailsViewModel

    
    init?(coder: NSCoder, viewModel: RocketDetailsViewModel) {
        
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        setupBindings()
        viewModel.viewDidLoad.onNext(())
    }
    
    private func setupBindings() {
        
        viewModel.titleText.asObservable().bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.descriptionText.asObservable().bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel.imageUrl.asObservable().subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] imageUrl in
            
            self?.mainImage.sd_setImage(with: imageUrl, completed: nil)
        }).disposed(by: disposeBag)
        
        readMoreButton.rx.tap.bind(to: viewModel.buttonTapObserver).disposed(by: disposeBag)
    }
}
