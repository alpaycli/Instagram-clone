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
