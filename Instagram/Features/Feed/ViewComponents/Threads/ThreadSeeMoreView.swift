//
//  ThreadSeeMoreView.swift
//  Instagram
//
//  Created by Alpay Calalli on 05.11.25.
//

import UIKit

final class ThreadSeeMoreView: UIView {
   
   private lazy var generalStackView: UIStackView = {
      let sv = UIStackView()
      sv.axis = .vertical
      sv.spacing = 18
      sv.alignment = .center
      sv.distribution = .fillEqually
      
      sv.addArrangedSubview(profileImagesStackView)
      sv.addArrangedSubview(descriptionLabel)
      sv.addArrangedSubview(seeMoreButton)
      
      descriptionLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
      seeMoreButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
      
      sv.translatesAutoresizingMaskIntoConstraints = false
      return sv
   }()
   
   private lazy var profileImagesStackView: UIStackView = {
      let sv = UIStackView()
      sv.axis = .horizontal
      sv.spacing = -14
      sv.alignment = .center
      sv.distribution = .fill
      
      sv.translatesAutoresizingMaskIntoConstraints = false
      return sv
   }()
   
   private lazy var seeMoreButton: UIButton = {
      let btn = UIButton()
      btn.setTitle("See More", for: .normal)
      btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
      btn.setTitleColor(.init(hexString: "#4A5CF9"), for: .normal)
      
      btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
   }()
   
   private lazy var descriptionLabel: IGSecondaryTitleLabel = {
      let l = IGSecondaryTitleLabel()
      l.font = .systemFont(ofSize: 12)
      l.numberOfLines = 0
      l.text = """
         See more from accounts you might 
         know on Threads
         """
      l.textAlignment = .center
      
      l.translatesAutoresizingMaskIntoConstraints = false
      return l
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
      layer.cornerRadius = 16
      backgroundColor = .white
      layer.borderWidth = 1
      layer.borderColor = UIColor.systemGray6.cgColor
      
      addSubviews(generalStackView)
   }
   
   private func layoutUI() {
      NSLayoutConstraint.activate([
         generalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
         generalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
         generalStackView.heightAnchor.constraint(equalToConstant: 140)
      ])
   }
   
   func set(profileImages: [String]) {
      guard profileImagesStackView.arrangedSubviews.isEmpty else { return }
      
      profileImagesStackView.heightAnchor.constraint(equalToConstant: 33).isActive = true
      for imageUrl in profileImages {
         let imageView = GFAvatarImageView(frame: .zero)
         imageView.downloadImage(fromURL: imageUrl)
         imageView.clipsToBounds = true
         
         imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
         imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
         
         imageView.layer.cornerRadius = 16
         imageView.layer.borderWidth = 3
         imageView.layer.borderColor = UIColor.systemBackground.cgColor
         
         profileImagesStackView.addArrangedSubview(imageView)
      }
   }
}
