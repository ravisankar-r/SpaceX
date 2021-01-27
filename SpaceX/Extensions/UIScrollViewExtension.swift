//
//  UIScrollViewExtension.swift
//  SpaceX
//
//  Created by Ravisankar on 27/01/21.
//

import UIKit

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
