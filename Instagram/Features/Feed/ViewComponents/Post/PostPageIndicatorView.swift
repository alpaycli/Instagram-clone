//
//  PostPageIndicatorView.swift
//  Instagram
//
//  Created by Alpay Calalli on 04.11.25.
//

import UIKit

class PostPageIndicatorView: UIView {
   
   private lazy var currentIndexLabel: IGTitleLabel = {
      let l = IGTitleLabel(textAlignment: .left, fontSize: 12, weight: .medium)
      l.textColor = .white
      return l
   }()
   
   init(totalPageCount: Int, currentIndex: Int = 0) {
      super.init(frame: .zero)
      self.currentIndexLabel.text = "\(currentIndex + 1)/\(totalPageCount)"
      setupUI()
      layoutUI()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      setupUI()
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func set(currentIndex: Int, totalPageCount: Int) {
      currentIndexLabel.text = "\(currentIndex + 1)/\(totalPageCount)"
   }
   
   private func setupUI() {
      addSubviews(currentIndexLabel)
      backgroundColor = .init(resource: .pageIndicatorBackground)
      clipsToBounds = true
      layer.cornerRadius = 13
      
      translatesAutoresizingMaskIntoConstraints = false
   }
   
   private func layoutUI() {
      NSLayoutConstraint.activate([
         currentIndexLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         currentIndexLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      ])
   }
}
