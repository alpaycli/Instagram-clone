//
//  PeopleSuggestionCell.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

import UIKit

class PeopleSuggestionCell: UICollectionViewCell {
   static let reuseId = "PeopleSuggestionCell"
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = .systemIndigo
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
