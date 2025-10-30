//
//  IGBodyLabel.swift
//  Instagram
//
//  Created by Alpay Calalli on 29.10.25.
//

import UIKit

class IGBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
      self.font = UIFont.systemFont(ofSize: fontSize, weight: .thin)
    }
    
    private func configure() {
//        textColor = .secondaryLabel
//        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
//        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
