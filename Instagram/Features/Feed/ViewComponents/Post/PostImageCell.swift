//
//  PostImageCell.swift
//  Instagram
//
//  Created by Alpay Calalli on 05.11.25.
//

import UIKit

class PostImageCell: UICollectionViewCell {
   static let reuseId = "PostImageCell"
   
   private lazy var imageView: GFAvatarImageView = {
      let imageView = GFAvatarImageView(frame: .zero)
      
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      addSubview(imageView)
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      NSLayoutConstraint.activate([
         imageView.heightAnchor.constraint(equalToConstant: contentView.frame.width),
         imageView.widthAnchor.constraint(equalToConstant: contentView.frame.width)
      ])
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func set(image imageUrl: String) {
      imageView.downloadImage(fromURL: imageUrl)
   }
}
