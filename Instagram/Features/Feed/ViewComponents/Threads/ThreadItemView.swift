//
//  ThreadItemView.swift
//  Instagram
//
//  Created by Alpay Calalli on 05.11.25.
//

import UIKit

final class ThreadItemView: UIView {
   
   private let generalStackView = UIStackView()
   private let userInfoStackView = UIStackView()
   
   private lazy var profileImageView: GFAvatarImageView = {
      let imageView = GFAvatarImageView(frame: .zero)
      imageView.layer.cornerRadius = 16
      imageView.clipsToBounds = true
      imageView.layer.borderColor = UIColor(hexString: "#B6A889").cgColor
      imageView.layer.borderWidth = 1
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
   }()
   
   private lazy var nameLabel: UILabel = {
      let l = UILabel()
      l.font = .systemFont(ofSize: 12, weight: .regular)
      l.translatesAutoresizingMaskIntoConstraints = false
      return l
   }()
   
   private lazy var timeLabel: UILabel = {
      let l = UILabel()
      l.font = .systemFont(ofSize: 12)
      l.textColor = .secondaryLabel
      l.translatesAutoresizingMaskIntoConstraints = false
      return l
   }()
   
   private lazy var moreButton: UIButton = {
      let btn = UIButton()
      btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
      btn.tintColor = .label
      btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
   }()
   
   private lazy var descriptionLabel: UILabel = {
      let l = UILabel()
      l.font = .systemFont(ofSize: 12, weight: .thin)
      l.numberOfLines = 0
      l.translatesAutoresizingMaskIntoConstraints = false
      return l
   }()
   
   private lazy var postImageView: GFAvatarImageView = {
      let imageView = GFAvatarImageView(frame: .zero)
      imageView.contentMode = .scaleAspectFill
//      imageView.backgroundColor = .clear
      imageView.clipsToBounds = true
      imageView.layer.cornerRadius = 10
      
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
   }()
   
   private lazy var reactionsView: ThreadReactionsView = {
      let v = ThreadReactionsView()
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
   }()
   
   private var postImageHeightConstraint: NSLayoutConstraint?
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      configureUserInfoStackView()
      configureGeneralStackView()
      setupUI()
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func configureGeneralStackView() {
      userInfoStackView.heightAnchor.constraint(equalToConstant: 34).isActive = true
      userInfoStackView.alignment = .center
      
      generalStackView.addArrangedSubview(userInfoStackView)
      generalStackView.addArrangedSubview(descriptionLabel)
      generalStackView.addArrangedSubview(reactionsView)
      
      generalStackView.axis = .vertical
      generalStackView.spacing = 10
      generalStackView.alignment = .leading
      generalStackView.distribution = .fill
      generalStackView.translatesAutoresizingMaskIntoConstraints = false
   }
   
   private func configureUserInfoStackView() {
      userInfoStackView.addArrangedSubview(profileImageView)
      userInfoStackView.addArrangedSubview(nameLabel)
      userInfoStackView.addArrangedSubview(timeLabel)
      
      NSLayoutConstraint.activate([
         profileImageView.heightAnchor.constraint(equalToConstant: 32),
         profileImageView.widthAnchor.constraint(equalToConstant: 32),
      ])
      
      userInfoStackView.axis = .horizontal
      userInfoStackView.spacing = 10
      userInfoStackView.alignment = .leading
      userInfoStackView.translatesAutoresizingMaskIntoConstraints = false
   }
   
   private func setupUI() {
      layer.cornerRadius = 16
      backgroundColor = .white
      layer.borderWidth = 1
      layer.borderColor = UIColor.systemGray6.cgColor
      
      addSubview(generalStackView)
      addSubview(moreButton)
   }
   
   private func layoutUI() {
       let padding: CGFloat = 16
       NSLayoutConstraint.activate([
           moreButton.topAnchor.constraint(equalTo: userInfoStackView.topAnchor),
           moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
           
           generalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 21),
           generalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
           generalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
           generalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
       ])
   }
   
   func set(_ post: ThreadPost) {
      profileImageView.downloadImage(fromURL: post.ownerPhoto)
      nameLabel.text = post.username
      if let createdAtString = post.createdAt,
         let createdAtDate = parseDateFromISO8601(iso8601Date: createdAtString)
      {
         timeLabel.text = Date.now.timePassed(from: createdAtDate)
      }
      descriptionLabel.text = post.text
      
      // Handle post image
      if let imageUrl = post.image {
         postImageView.downloadImage(fromURL: imageUrl)
         
         if postImageView.superview == nil {
            generalStackView.insertArrangedSubview(postImageView, at: 2)
            postImageHeightConstraint = postImageView.heightAnchor.constraint(equalToConstant: 150)
            postImageHeightConstraint?.isActive = true
         }
      } else {
         if postImageView.superview != nil {
            generalStackView.removeArrangedSubview(postImageView)
            postImageView.removeFromSuperview()
         }
         postImageHeightConstraint?.isActive = false
         postImageHeightConstraint = nil
      }
      
      reactionsView.set(post)
   }
}
