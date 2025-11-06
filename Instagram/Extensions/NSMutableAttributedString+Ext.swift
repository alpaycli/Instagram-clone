//
//  NSMutableAttributedString+Ext.swift
//  Instagram
//
//  Created by Alpay Calalli on 29.10.25.
//

import UIKit
import Foundation

extension NSMutableAttributedString {
   func bold(_ value: String, fontSize: CGFloat) -> NSMutableAttributedString {
      
      let attributes:[NSAttributedString.Key : Any] = [
         .font : UIFont.systemFont(ofSize: fontSize, weight: .bold)
      ]
      
      self.append(NSAttributedString(string: value, attributes:attributes))
      return self
   }
   
   func normal(_ value: String, fontSize: CGFloat) -> NSMutableAttributedString {
      
      let attributes:[NSAttributedString.Key : Any] = [
         .font : UIFont.systemFont(ofSize: fontSize, weight: .regular),
      ]
      
      self.append(NSAttributedString(string: value, attributes:attributes))
      return self
   }
}
