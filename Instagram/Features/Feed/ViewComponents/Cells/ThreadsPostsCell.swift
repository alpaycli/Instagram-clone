import UIKit

final class ThreadsPostsCell: UICollectionViewCell {
   
   static let reuseID = "ThreadsPostsCell"
   
   private var model: ThreadsModel = .init(post: PostModel.mockData[1].data)
     
   private lazy var headerView: ThreadsHeaderView = {
      let v = ThreadsHeaderView()
      
      return v
   }()
   private lazy var containerView: UIView = {
      let v = UIView()
      v.backgroundColor = .white
      v.layer.cornerRadius = 16
      v.layer.masksToBounds = true
      return v
   }()
   
   private lazy var pageControl: UIPageControl = {
      let control = UIPageControl()
      control.currentPageIndicatorTintColor = .label
      control.pageIndicatorTintColor = .systemGray3
      return control
   }()
   
   private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .horizontal
       layout.minimumLineSpacing = 16 // Space between cells
      let width = UIScreen.main.bounds.size.width - 32
      layout.estimatedItemSize = CGSize(width: width, height: 10)

       
       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       collectionView.isPagingEnabled = false // We'll handle paging manually
       collectionView.backgroundColor = .clear
       collectionView.showsHorizontalScrollIndicator = false
       collectionView.dataSource = self
       collectionView.delegate = self
       collectionView.decelerationRate = .fast
       collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
       collectionView.register(ThreadItemCell.self, forCellWithReuseIdentifier: ThreadItemCell.reuseID)
       return collectionView
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func layoutUI() {
      backgroundColor = .clear // so outer feed gray shows
      collectionView.backgroundColor = .systemGray5// Gray background
      
      contentView.addSubview(containerView)
      containerView.addSubviews(headerView, collectionView, pageControl)

      containerView.translatesAutoresizingMaskIntoConstraints = false
      headerView.translatesAutoresizingMaskIntoConstraints = false
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      pageControl.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
         containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
         containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
         containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
         
         headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
         headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
         headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
         headerView.heightAnchor.constraint(equalToConstant: 44),
         
         collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
         collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
         collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
         collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
         
         pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 18),
         pageControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
         pageControl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4)

      ])
   }
   
   func set(_ model: ThreadsModel) {
      self.model = model
      let subtitle = model.joinCount > 1 ? "\(model.joinCount) others joined" : ""
      headerView.set(title: "Threads", subtitle: subtitle, avatar: nil)
      pageControl.numberOfPages = model.posts.count
      pageControl.currentPage = 0
      collectionView.reloadData()
   }
}

// MARK: - UICollectionViewDataSource
extension ThreadsPostsCell: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      model.posts.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(
         withReuseIdentifier: ThreadItemCell.reuseID,
         for: indexPath
      ) as! ThreadItemCell
      cell.set(model.posts[indexPath.item])
      return cell
   }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ThreadsPostsCell: UICollectionViewDelegateFlowLayout {
//   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//      let width = collectionView.bounds.width - 32 // Subtract left + right padding
//      let height = collectionView.bounds.height
//      return CGSize(width: width, height: height)
//   }
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
       pageControl.currentPage = page
   }
}

// MARK: - UIScrollViewDelegate (Paging behavior)

extension ThreadsPostsCell: UIScrollViewDelegate {
   func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      let cellWidth = scrollView.bounds.width - 32
      let spacing: CGFloat = 16
      let totalCellWidth = cellWidth + spacing
      
      let targetX = targetContentOffset.pointee.x + 16
      let index = round(targetX / totalCellWidth)
      let newOffset = index * totalCellWidth - 16
      
      targetContentOffset.pointee.x = max(newOffset, -16)
   }
}

// MARK: - ThreadItemCell
final class ThreadItemCell: UICollectionViewCell {
   static let reuseID = "ThreadItemCell"
   
   lazy var width: NSLayoutConstraint = {
       let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
       width.isActive = true
       return width
   }()

   override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
       width.constant = bounds.size.width
       return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
   }
   
   private let generalStackView = UIStackView()
   private let userInfoStackView = UIStackView()
   private let profileImageView: GFAvatarImageView = {
      let imageView = GFAvatarImageView(frame: .zero)
      imageView.layer.cornerRadius = 6
      imageView.clipsToBounds = true
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
      imageView.contentMode = .scaleAspectFit
      imageView.backgroundColor = .clear
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
   }()
   
   private lazy var reactionsView: ThreadReactionsView = {
      let v = ThreadReactionsView()
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
   }()
   
   // Store the height constraint so we can manage it
   private var postImageHeightConstraint: NSLayoutConstraint?
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      configureUserInfoStackView()
      configureGeneralStackView()
      configure()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   // CRITICAL: Reset cell state when reused
   override func prepareForReuse() {
       super.prepareForReuse()
       
       // Reset images to prevent wrong images appearing
       profileImageView.image = nil
       postImageView.image = nil
       
       // Cancel any ongoing image downloads
       profileImageView.cancelImageDownload() // Implement this in GFAvatarImageView
       postImageView.cancelImageDownload()
       
       // Remove postImageView from stack if it's there
       if postImageView.superview != nil {
           generalStackView.removeArrangedSubview(postImageView)
           postImageView.removeFromSuperview()
       }
       
       // Deactivate the height constraint
       postImageHeightConstraint?.isActive = false
       postImageHeightConstraint = nil
       
       // Reset labels
       nameLabel.text = nil
       timeLabel.text = nil
       descriptionLabel.text = nil
   }
   
   private func configureGeneralStackView() {
      userInfoStackView.heightAnchor.constraint(equalToConstant: 34).isActive = true
      userInfoStackView.alignment = .center
      
      generalStackView.addArrangedSubview(userInfoStackView)
      generalStackView.addArrangedSubview(descriptionLabel)
      generalStackView.addArrangedSubview(reactionsView)
      
//      [userInfoStackView, descriptionLabel, postImageView, reactionsView].forEach({ $0.backgroundColor = [UIColor.lightGray, .darkGray, .cyan, .green, .magenta].randomElement() })
            
      NSLayoutConstraint.activate([
         reactionsView.widthAnchor.constraint(equalToConstant: contentView.frame.width)
      ])
      
      generalStackView.axis = .vertical
      generalStackView.spacing = 10
      generalStackView.alignment = .top
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
   
   private func configure() {
       contentView.layer.cornerRadius = 16
       contentView.backgroundColor = .white
       contentView.layer.borderWidth = 1
       contentView.layer.borderColor = UIColor.systemGray6.cgColor
       
       contentView.addSubview(generalStackView)
       contentView.addSubview(moreButton)
       
       let padding: CGFloat = 16
       
       NSLayoutConstraint.activate([
           moreButton.topAnchor.constraint(equalTo: userInfoStackView.topAnchor),
           moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
           
           generalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 21),
           generalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
           generalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
           generalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
       ])
   }
   
   func set(_ post: ThreadPost) {
      profileImageView.downloadImage(fromURL: post.ownerPhoto)
      nameLabel.text = post.username
      timeLabel.text = "5h"
      descriptionLabel.text = post.text
      
      // Handle post image
      if let imageUrl = post.image {
         postImageView.downloadImage(fromURL: imageUrl)
         
         // Only add if not already in the stack view
         if postImageView.superview == nil {
            generalStackView.insertArrangedSubview(postImageView, at: 2)
            
            // Create and store the constraint
            postImageHeightConstraint = postImageView.heightAnchor.constraint(equalToConstant: 150)
            postImageHeightConstraint?.isActive = true
         }
      } else {
         // Remove image view if there's no image
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

import SwiftUI

struct ThreadItemCellView: UIViewRepresentable {
   func makeUIView(context: Context) -> ThreadItemCell {
      ThreadItemCell()
   }
   
   func updateUIView(_ uiView: ThreadItemCell, context: Context) {
      
   }
}

