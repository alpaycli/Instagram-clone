//
//  StoryCell.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

import UIKit

class StoryCell: UICollectionViewCell {
   static let reuseId = "StoryCell"
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      layer.cornerRadius = 24
      backgroundColor = .red
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
