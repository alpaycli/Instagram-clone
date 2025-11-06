//
//  ShopNowBannerView.swift
//  Instagram
//
//  Created by Alpay Calalli on 03.11.25.
//

import UIKit

class ShopNowBannerView: UIView {
   
   private lazy var titleLabel: IGTitleLabel = {
      let l = IGTitleLabel(textAlignment: .left, fontSize: 10, weight: .medium)
      
      l.text = "Shop now"
      l.textColor = .white
      
      return l
   }()
   
   private lazy var arrowImageView: UIImageView = {
      let v = UIImageView()
      v.image = .init(systemName: "chevron.right")
      v.tintColor = .white
      
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      setupUI()
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func setupUI() {
      backgroundColor = .init(hexString: "#3997F1")
      addSubviews(titleLabel, arrowImageView)
      
      translatesAutoresizingMaskIntoConstraints = false
   }
   
   private func layoutUI() {
      
      let horizontalPadding: CGFloat = 11
      let verticalPadding: CGFloat = 7
      NSLayoutConstraint.activate([
         titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
         titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
         titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding),
         
         arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
         arrowImageView.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding + 2),
         arrowImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding - 2),
         
      ])
   }
}
