//
//  PostPageIndicatorView.swift
//  Instagram
//
//  Created by Alpay Calalli on 04.11.25.
//

import UIKit

class PostPageIndicatorView: UIView {
   private var currentIndexLabel: IGTitleLabel = {
      let l = IGTitleLabel(textAlignment: .left, fontSize: 12, weight: .medium)
      l.textColor = .white
      return l
   }()
   
   init(totalPageCount: Int, currentIndex: Int = 0) {
      super.init(frame: .zero)
      self.currentIndexLabel.text = "\(currentIndex + 1)/\(totalPageCount)"
      layoutUI()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func set(currentIndex: Int, totalPageCount: Int) {
      currentIndexLabel.text = "\(currentIndex + 1)/\(totalPageCount)"
   }
   
   private func layoutUI() {
      addSubviews(currentIndexLabel)
      backgroundColor = .init(resource: .pageIndicatorBackground)
      clipsToBounds = true
      layer.cornerRadius = 13
      
      translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         currentIndexLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         currentIndexLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      ])
   }
}

#Preview {
   let v = PostPageIndicatorView(totalPageCount: 3)
   v.frame = CGRect(x: 100, y: 50, width: 100, height: 100)
   return v
}
