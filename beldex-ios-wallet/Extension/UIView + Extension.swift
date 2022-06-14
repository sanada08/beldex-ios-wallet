//
//  UIView + Extension.swift
//  beldex-ios-wallet
//
//  Created by Sanada Yukimura on 6/14/22.
//

import UIKit

extension UIView {
    
    var height: CGFloat {
        get { return self.frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var y: CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
}

// MARK: - Find View

extension UIView {
    
    func findView(_ filter: (UIView) -> Bool) -> UIView? {
        if filter(self) {
            return self
        } else {
            var resultView: UIView?
            for subview in subviews {
                if filter(subview) {
                    resultView = subview
                    break
                } else {
                    if let result = subview.findView(filter) {
                        resultView = result
                        break
                    }
                }
            }
            return resultView
        }
    }
}

