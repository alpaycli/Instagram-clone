//
//  NormalPostCell.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

import SafariServices
import UIKit

class PostCell: UICollectionViewCell {
   static let reuseId = "PostCell"
   
   private var images: [String] = []
   
   private lazy var headerView: PostHeaderView = {
      let v = PostHeaderView()
      
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
   }()
   
   private lazy var pageIndicatorView: PostPageIndicatorView = {
      let v = PostPageIndicatorView(totalPageCount: images.count, currentIndex: 0)
      
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
   }()
   
   private lazy var postImagesCollectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.minimumInteritemSpacing = 0
      layout.minimumLineSpacing = 0
      //       layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
      
      layout.itemSize = CGSize(width: 375, height: 375)
      
      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      collectionView.backgroundColor = .clear
      collectionView.showsHorizontalScrollIndicator = false
      collectionView.isPagingEnabled = true
      collectionView.decelerationRate = .normal
      collectionView.dataSource = self
      collectionView.delegate = self
      collectionView.register(PostImageCell.self, forCellWithReuseIdentifier: PostImageCell.reuseId)
      
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      return collectionView
   }()
   
   private lazy var likeButton: UIButton = {
      let btn = UIButton()
      btn.setImage(PostActionIcon.like, for: .normal)
      
      btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
   }()
   
   private lazy var commentButton: UIButton = {
      let btn = UIButton()
      btn.setImage(PostActionIcon.comment, for: .normal)
      
      btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
   }()
   
   private lazy var shareButton: UIButton = {
      let btn = UIButton()
      btn.setImage(PostActionIcon.share, for: .normal)
      
      btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
   }()
   
   private lazy var pageControl: UIPageControl = {
      let control = UIPageControl()
      control.currentPageIndicatorTintColor = .label
      control.pageIndicatorTintColor = .systemGray3
      
      control.translatesAutoresizingMaskIntoConstraints = false
      return control
   }()
   
   private lazy var saveButton: UIButton = {
      let btn = UIButton()
      btn.setImage(PostActionIcon.save, for: .normal)
      
      btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
   }()
   
   private lazy var likedByLabel: IGBodyLabel = {
      let l = IGBodyLabel(textAlignment: .left, fontSize: 13)
      
      return l
   }()
   
   private lazy var descriptionLabel: IGBodyLabel = {
      let l = IGBodyLabel(textAlignment: .left, fontSize: 13)
      l.lineBreakMode = .byTruncatingTail
      l.numberOfLines = 0
      return l
   }()
   
   private lazy var postDateLabel: IGBodyLabel = {
      let l = IGBodyLabel(textAlignment: .left, fontSize: 11)
      
      return l
   }()
   
   private var shoppingUrl: String = ""
   private lazy var shopNowBannerView: ShopNowBannerView = {
      let v = ShopNowBannerView()
      
      let shopAdGesture = UITapGestureRecognizer(target: self, action: #selector(handleShopNowTap(_:)))
      v.addGestureRecognizer(shopAdGesture)
      
      return v
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      layoutUI()
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      if let layout = postImagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
         let newSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.width)
         if layout.itemSize != newSize {
            layout.itemSize = newSize
            layout.invalidateLayout()
         }
      }
   }
   
   override func prepareForReuse() {
      super.prepareForReuse()
      
      // reset values here
      postImagesCollectionView.setContentOffset(.zero, animated: false)
      postImagesCollectionView.reloadData()
      
      likedByLabel.text = nil
      descriptionLabel.text = nil
      postDateLabel.text = nil
      images = []
      
      shopNowBannerView.removeFromSuperview()
      
      pageControl.isHidden = false
      pageIndicatorView.isHidden = false
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func layoutUI() {
      contentView.addSubviews(headerView, postImagesCollectionView, pageIndicatorView, likeButton, commentButton, shareButton, pageControl, saveButton, likedByLabel, descriptionLabel, postDateLabel)
      
      if let layout = postImagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
         layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
         layout.minimumInteritemSpacing = 0
         layout.minimumLineSpacing = 0
      }
      postImagesCollectionView.heightAnchor.constraint(equalTo: postImagesCollectionView.widthAnchor).isActive = true
      
      
      let leadingPadding: CGFloat = 14
      NSLayoutConstraint.activate([
         headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
         headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
         headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         headerView.heightAnchor.constraint(equalToConstant: 44),
         
         postImagesCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
         postImagesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         postImagesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         //         postImagesCollectionView.heightAnchor.constraint(equalToConstant: 375),
         
         pageIndicatorView.topAnchor.constraint(equalTo: postImagesCollectionView.topAnchor, constant: 16),
         pageIndicatorView.trailingAnchor.constraint(equalTo: postImagesCollectionView.trailingAnchor, constant: -16),
         pageIndicatorView.heightAnchor.constraint(equalToConstant: 26),
         pageIndicatorView.widthAnchor.constraint(equalToConstant: 34),
         
         likeButton.topAnchor.constraint(equalTo: postImagesCollectionView.bottomAnchor, constant: 13),
         likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingPadding),
         likeButton.widthAnchor.constraint(equalToConstant: 22),
         likeButton.heightAnchor.constraint(equalToConstant: 22),
         
         commentButton.topAnchor.constraint(equalTo: likeButton.topAnchor),
         commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 17),
         commentButton.widthAnchor.constraint(equalToConstant: 22),
         commentButton.heightAnchor.constraint(equalToConstant: 22),
         
         shareButton.topAnchor.constraint(equalTo: likeButton.topAnchor),
         shareButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 17),
         shareButton.widthAnchor.constraint(equalToConstant: 22),
         shareButton.heightAnchor.constraint(equalToConstant: 22),
         
         pageControl.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
         pageControl.centerXAnchor.constraint(equalTo: postImagesCollectionView.centerXAnchor),
         
         saveButton.topAnchor.constraint(equalTo: likeButton.topAnchor),
         saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -leadingPadding),
         saveButton.widthAnchor.constraint(equalToConstant: 22),
         saveButton.heightAnchor.constraint(equalToConstant: 22),
         
         likedByLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 6),
         likedByLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingPadding),
         likedByLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -leadingPadding),
         likedByLabel.heightAnchor.constraint(equalToConstant: 20),
         
         descriptionLabel.topAnchor.constraint(equalTo: likedByLabel.bottomAnchor, constant: 5),
         descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingPadding),
         descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -leadingPadding),
         
         postDateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
         postDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingPadding),
         postDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -leadingPadding),
         postDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
      ])
      
   }
   
   private func configureAdBannerView() {
      // Her ehtimal, basqa (sehv) yerden cagirilanda return elesin deye guard check
      guard !shoppingUrl.isEmpty else { return }
      
      contentView.addSubview(shopNowBannerView)
      NSLayoutConstraint.activate([
         shopNowBannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         shopNowBannerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         shopNowBannerView.bottomAnchor.constraint(equalTo: postImagesCollectionView.bottomAnchor, constant: 0),
         shopNowBannerView.heightAnchor.constraint(equalToConstant: 38),
      ])
      
   }
}

// MARK: - Set functions

extension PostCell {
   func set(_ model: NormalPostModel) {
      if let url = model.userPhoto {
         headerView.set(
            title: model.username,
            subtitle: model.location,
            avatarUrl: url
         )
      }
      images = model.images.filter({ !$0.isEmpty })
      
      pageControl.numberOfPages = model.images.count
      pageControl.currentPage = 0
      pageIndicatorView.set(currentIndex: 0, totalPageCount: images.count)
      if images.count == 1 {
         pageControl.isHidden = true
         pageIndicatorView.isHidden = true
      }
      
      likedByLabel.attributedText = NSMutableAttributedString()
         .normal("Liked by ", fontSize: 13)
         .bold(model.likedBy.first ?? "N/A", fontSize: 13)
         .normal(" and ", fontSize: 13)
         .bold("\(model.likeCount) others", fontSize: 13)
      descriptionLabel.attributedText = NSMutableAttributedString()
         .bold(model.username, fontSize: 13)
         .normal(" \(model.description)", fontSize: 13)
      postDateLabel.text = model.createdAt.formatted()
   }
   
   func set(_ model: AdPostModel) {
      if let url = model.advertiserPhoto {
         headerView.set(
            title: model.advertiserName,
            subtitle: "Sponsored",
            avatarUrl: url
         )
      }
      
      if let adPostImage = model.image {
         images.append(adPostImage)
      }
      if let url = model.shoppingUrl {
         shoppingUrl = url
      }
      
      pageControl.numberOfPages = 0
      pageControl.currentPage = 0
      pageIndicatorView.set(currentIndex: 0, totalPageCount: images.count)
      // ad only has 1 image
      pageIndicatorView.isHidden = true
      
      likedByLabel.attributedText = NSMutableAttributedString()
         .normal("Liked by ", fontSize: 13)
         .bold(model.likedBy.first ?? "N/A", fontSize: 13)
         .normal(" and ", fontSize: 13)
         .bold("\(model.likeCount) others", fontSize: 13)
      descriptionLabel.attributedText = NSMutableAttributedString()
         .bold(model.advertiserName, fontSize: 13)
         .normal(" \(model.description)", fontSize: 13)
      postDateLabel.text = model.createdAt.formatted()
      
      configureAdBannerView()
   }
   
   /// For previews
   func set(
      profileImageUrl: String,
      name: String,
      location: String,
      postImageUrl: String,
      likedBy: String,
      likeCount: Int,
      description: String,
      postDateLabel: Date
   ) {
      headerView.set(
         title: name,
         subtitle: location,
         avatarUrl: profileImageUrl
      )
      likedByLabel.attributedText = NSMutableAttributedString()
         .normal("Liked by ", fontSize: 13)
         .bold(likedBy, fontSize: 13)
         .normal(" and ", fontSize: 13)
         .bold("\(likeCount) others", fontSize: 13)
      
      descriptionLabel.attributedText = NSMutableAttributedString()
         .bold(name, fontSize: 13)
         .normal(description, fontSize: 13)
      
      //      postImageView.downloadImage(fromURL: postImageUrl)
      
      pageControl.numberOfPages = 3
      pageControl.currentPage = 0
      
      self.postDateLabel.text = postDateLabel.formatted()
   }

}

// MARK: - Data Source

extension PostCell: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      images.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let image = images[indexPath.item]
      let cell = collectionView.dequeueReusableCell(
         withReuseIdentifier: PostImageCell.reuseId,
         for: indexPath
      ) as! PostImageCell
      cell.set(image: image)
      return cell
   }
}

// MARK: - Pagination handling

extension PostCell: UICollectionViewDelegate {
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
      pageControl.currentPage = page
      pageIndicatorView.set(currentIndex: page, totalPageCount: images.count)
   }
   
}

// MARK: - Button actions

extension PostCell {
   @objc func handleShopNowTap(_ sender: UITapGestureRecognizer) {
      if let url = URL(string: shoppingUrl) {
         let vc = SFSafariViewController(url: url)
         vc.delegate = self
         
         if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
               topController = presentedViewController
            }
            
            topController.present(vc, animated: true, completion: nil)
         }
         
      }
   }
}

extension PostCell: SFSafariViewControllerDelegate {}
