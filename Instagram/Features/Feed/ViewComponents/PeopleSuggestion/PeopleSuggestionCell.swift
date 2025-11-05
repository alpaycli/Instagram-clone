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
         containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         
         headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 26),
         headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalPadding),
         headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -horizontalPadding),
         headerView.heightAnchor.constraint(equalToConstant: 20),
         
         collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
         collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: horizontalPadding),
         collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
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
