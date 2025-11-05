//
//  PeopleSuggestionItemCell.swift
//  Instagram
//
//  Created by Alpay Calalli on 05.11.25.
//

import UIKit

class PeopleSuggestionItemCell: UICollectionViewCell {
   static let reuseId = "PeopleSuggestionItemCell"
   
   private lazy var dismissButton: UIButton = {
      let btn = UIButton()
      btn.setImage(.init(systemName: "xmark"), for: .normal)
      btn.tintColor = .systemGray
      
      btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
   }()
   
   private lazy var profileImageView: GFAvatarImageView = {
      let imageView = GFAvatarImageView(frame: .zero)
      imageView.clipsToBounds = true
      imageView.layer.cornerRadius = 43
      imageView.layer.borderWidth = 0.1
      imageView.layer.borderColor = UIColor(hexString: "E5C7B0").cgColor
      
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
   }()
   
   private lazy var titleLabel: IGTitleLabel = {
      let l = IGTitleLabel(textAlignment: .left, fontSize: 14, weight: .semibold)
      
      return l
   }()
   
   private lazy var subtitleLabel: IGSecondaryTitleLabel = {
      let l = IGSecondaryTitleLabel(alignment: .center, fontSize: 12)
      return l
   }()
   
   private lazy var actionButton: UIButton = {
      let btn = UIButton(type: .custom)
      btn.setTitle(.init(localized:"Follow"), for: .normal)
      btn.setTitleColor(.white, for: .normal)
      btn.backgroundColor = .init(hexString: "495DF9")
      btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
      btn.layer.cornerRadius = 7
      
      btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      setupUI()
      layoutUI()
   }
   
   // CRITICAL: Reset cell state when reused
   override func prepareForReuse() {
      super.prepareForReuse()
      
      // Reset images to prevent wrong images appearing
      profileImageView.image = nil
      
      // Cancel any ongoing image downloads
      profileImageView.cancelImageDownload()
      
      // Reset labels
      titleLabel.text = nil
      subtitleLabel.text = nil
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func set(_ item: PeopleSuggestion) {
      if !item.photo.isEmpty {
         profileImageView.downloadImage(fromURL: item.photo)
      }
      titleLabel.text = item.username
      subtitleLabel.text = item.fullName
   }
   
   private func setupUI() {
      backgroundColor = .white
      layer.cornerRadius = 10
      layer.borderWidth = 1
      layer.borderColor = UIColor(hexString: "#ECF0F3").cgColor
      
      contentView.addSubviews(dismissButton, profileImageView, titleLabel, subtitleLabel, actionButton)
   }
   
   private func layoutUI() {
      NSLayoutConstraint.activate([
         dismissButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
         dismissButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
         dismissButton.heightAnchor.constraint(equalToConstant: 14),
         dismissButton.widthAnchor.constraint(equalToConstant: 14),
         
         profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
         profileImageView.heightAnchor.constraint(equalToConstant: 86),
         profileImageView.widthAnchor.constraint(equalToConstant: 86),
         profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
         
         titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
         titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
         titleLabel.heightAnchor.constraint(equalToConstant: 17),
         
         subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
         subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
         subtitleLabel.heightAnchor.constraint(equalToConstant: 15),
         
         actionButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 7),
         actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
         actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
         actionButton.heightAnchor.constraint(equalToConstant: 31),
         actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
      ])
   }
}
