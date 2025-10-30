//
//  NSMutableAttributedString+Ext.swift
//  Instagram
//
//  Created by Alpay Calalli on 29.10.25.
//

import UIKit
import Foundation

extension NSMutableAttributedString {
//    var fontSize: CGFloat { return 20 }
//    var boldFont: UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
//    var normalFont: UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
   func bold(_ value:String, fontSize: CGFloat) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
         .font : UIFont.systemFont(ofSize: fontSize, weight: .bold)
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String, fontSize: CGFloat) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
         .font : UIFont.systemFont(ofSize: fontSize, weight: .regular),
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
//    /* Other styling methods */
//    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
//        
//        let attributes:[NSAttributedString.Key : Any] = [
//            .font :  normalFont,
//            .foregroundColor : UIColor.white,
//            .backgroundColor : UIColor.orange
//        ]
//        
//        self.append(NSAttributedString(string: value, attributes:attributes))
//        return self
//    }
//    
//    func blackHighlight(_ value:String) -> NSMutableAttributedString {
//        
//        let attributes:[NSAttributedString.Key : Any] = [
//            .font :  normalFont,
//            .foregroundColor : UIColor.white,
//            .backgroundColor : UIColor.black
//            
//        ]
//        
//        self.append(NSAttributedString(string: value, attributes:attributes))
//        return self
//    }
//    
//    func underlined(_ value:String) -> NSMutableAttributedString {
//        
//        let attributes:[NSAttributedString.Key : Any] = [
//            .font :  normalFont,
//            .underlineStyle : NSUnderlineStyle.single.rawValue
//            
//        ]
//        
//        self.append(NSAttributedString(string: value, attributes:attributes))
//        return self
//    }
}
