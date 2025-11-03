//
//  UIView+Ext.swift
//  Instagram
//
//  Created by Alpay Calalli on 29.10.25.
//

import UIKit

extension UIView {
   func addSubviews(_ views: UIView...) {
      for view in views {
         addSubview(view)
      }
   }
}

extension UIImageView {

    fileprivate var bezierPathIdentifier:String { return "bezierPathBorderLayer" }

    fileprivate var bezierPathBorder:CAShapeLayer? {
        return (self.layer.sublayers?.filter({ (layer) -> Bool in
            return layer.name == self.bezierPathIdentifier && (layer as? CAShapeLayer) != nil
        }) as? [CAShapeLayer])?.first
    }

    func bezierPathBorder(_ color:UIColor = .white, width: CGFloat = 1) {

        var border = self.bezierPathBorder
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius:self.layer.cornerRadius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask

        if (border == nil) {
            border = CAShapeLayer()
            border!.name = self.bezierPathIdentifier
            self.layer.addSublayer(border!)
        }

        border!.frame = self.bounds
        let pathUsingCorrectInsetIfAny =
            UIBezierPath(roundedRect: border!.bounds, cornerRadius:self.layer.cornerRadius)

        border!.path = pathUsingCorrectInsetIfAny.cgPath
        border!.fillColor = UIColor.clear.cgColor
        border!.strokeColor = color.cgColor
        border!.lineWidth = width * 2
    }

    func removeBezierPathBorder() {
        self.layer.mask = nil
        self.bezierPathBorder?.removeFromSuperlayer()
    }

}

