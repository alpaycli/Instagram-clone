//
//  AdPostCell.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

import UIKit

class AdPostCell: UICollectionViewCell {
   static let reuseId = "AdPostCell"
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = .yellow
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
