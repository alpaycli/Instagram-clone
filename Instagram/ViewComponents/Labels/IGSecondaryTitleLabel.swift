//
//  IGSecondaryTitleLabel.swift
//  Instagram
//
//  Created by Alpay Calalli on 29.10.25.
//

import UIKit

class IGSecondaryTitleLabel: UILabel {
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   convenience init(alignment: NSTextAlignment = .left, fontSize: CGFloat) {
      self.init(frame: .zero)
      textAlignment = alignment
      font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
   }
   
   private func configure() {
      textColor = .secondaryLabel
      adjustsFontSizeToFitWidth = true
      minimumScaleFactor = 0.9
      lineBreakMode = .byTruncatingTail
      translatesAutoresizingMaskIntoConstraints = false
   }
}
