//
//  StoryBoardIdentifiable.swift
//  SpaceX
//
//  Created by Ravisankar on 27/01/21.
//

import UIKit

protocol StoryboardIdentifiable: AnyObject {
    
    static var viewControllerIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    
    static var viewControllerIdentifier: String {
            return String(describing: self)
        }
}

extension UIViewController: StoryboardIdentifiable { }
