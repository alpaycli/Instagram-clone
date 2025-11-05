//
//  PeopleSuggestionCell.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

import UIKit

class PeopleSuggestionCell: UICollectionViewCell {
   static let reuseId = "PeopleSuggestionCell"
   
   private var suggestions: [PeopleSuggestion] = []
   
   private lazy var containerView: UIView = {
      let v = UIView()
      v.layer.cornerRadius = 16
      v.layer.masksToBounds = true
      
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
   }()
   
   private lazy var headerView: PeopleSuggestionHeaderView = {
      let v = PeopleSuggestionHeaderView()
      v.onSeeAllButtonTapped = { print("see all -- tapped") }
      
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
   }()
   private lazy var collectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.minimumLineSpacing = 5
//      let width = UIScreen.main.bounds.size.width / 2.5
//     layout.estimatedItemSize = CGSize(width: width, height: 10)

      let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
      cv.backgroundColor = .clear
      cv.showsHorizontalScrollIndicator = false
      cv.dataSource = self
      cv.delegate = self
      cv.isScrollEnabled = true
//      cv.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
      cv.register(PeopleSuggestionItemCell.self, forCellWithReuseIdentifier: PeopleSuggestionItemCell.reuseId)
      
      cv.translatesAutoresizingMaskIntoConstraints = false
      return cv
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func set(_ suggestions: [PeopleSuggestion]) {
      self.suggestions = suggestions
      collectionView.reloadData()
   }
   
   private func layoutUI() {
      contentView.addSubview(containerView)
      containerView.addSubviews(headerView, collectionView)
      
      let horizontalPadding: CGFloat = 8
      NSLayoutConstraint.activate([
         containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
//         containerView.heightAnchor.constraint(equalToConstant: 260),
         containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         
         headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 26),
         headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalPadding),
         headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -horizontalPadding),
         headerView.heightAnchor.constraint(equalToConstant: 20),
         
         collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
         collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalPadding),
         collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//         collectionView.heightAnchor.constraint(equalToConstant: 200),
         collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
      ])
   }
}

extension PeopleSuggestionCell: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      suggestions.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let item = suggestions[indexPath.item]
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeopleSuggestionItemCell.reuseId, for: indexPath) as! PeopleSuggestionItemCell
      cell.set(item)
      
      return cell
   }
}

extension PeopleSuggestionCell: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width = collectionView.bounds.width / 2.5
//      let height = collectionView.bounds.height
      let height: CGFloat = 190
      return CGSize(width: width, height: height)
   }
}

class PeopleSuggestionHeaderView: UIView {
   var onSeeAllButtonTapped: (() -> Void)?

   private lazy var titleLabel: IGTitleLabel = {
      let l = IGTitleLabel(textAlignment: .left, fontSize: 14, weight: .semibold)
      l.text = .init(localized: "Suggested for you")
      
      return l
   }()
   
   private lazy var actionButton: UIButton = {
      let btn = UIButton()
      btn.setTitle(.init(localized: "See all"), for: .normal)
      btn.setTitleColor(.blue, for: .normal)
      btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
      btn.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
         
      btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func layoutUI() {
      addSubviews(titleLabel, actionButton)
      
      NSLayoutConstraint.activate([
         titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
         titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
         titleLabel.heightAnchor.constraint(equalToConstant: 19),
         
         actionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
         actionButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
         actionButton.heightAnchor.constraint(equalToConstant: 19),
      ])
   }
   
   @objc func seeAllButtonTapped() {
      onSeeAllButtonTapped?()
   }
}

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
       profileImageView.cancelImageDownload() // Implement this in GFAvatarImageView
      
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
   }
   
   private func layoutUI() {
      contentView.addSubviews(dismissButton, profileImageView, titleLabel, subtitleLabel, actionButton)
      
      NSLayoutConstraint.activate([
         dismissButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
         dismissButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
         dismissButton.heightAnchor.constraint(equalToConstant: 14),
         dismissButton.widthAnchor.constraint(equalToConstant: 14),
         
         profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
//         profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
//         profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
//         profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
         
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
