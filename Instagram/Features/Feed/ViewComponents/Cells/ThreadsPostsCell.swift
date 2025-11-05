import UIKit

final class ThreadsPostsCell: UICollectionViewCell {
   
   static let reuseID = "ThreadsPostsCell"
   
   private var model: ThreadsModel = .init(post: PostModel.mockData[1].data)
   private var threadItemViews: [ThreadItemView] = []
     
   private lazy var headerView: PostHeaderView = {
      let v = PostHeaderView()
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
   }()
   
   private lazy var containerView: UIView = {
      let v = UIView()
      v.layer.cornerRadius = 16
      v.layer.masksToBounds = true
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
   }()
   
   private lazy var pageControl: UIPageControl = {
      let control = UIPageControl()
      control.currentPageIndicatorTintColor = .label
      control.pageIndicatorTintColor = .systemGray3
      control.translatesAutoresizingMaskIntoConstraints = false
      return control
   }()
   
   private lazy var scrollView: UIScrollView = {
       let sv = UIScrollView()
       sv.isPagingEnabled = false
       sv.backgroundColor = .clear
       sv.showsHorizontalScrollIndicator = false
       sv.delegate = self
       sv.decelerationRate = .fast
       sv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
       sv.translatesAutoresizingMaskIntoConstraints = false
       return sv
   }()
   
   private lazy var contentStackView: UIStackView = {
       let sv = UIStackView()
       sv.axis = .horizontal
       sv.spacing = 16
      sv.alignment = .center
       sv.distribution = .fill
       sv.translatesAutoresizingMaskIntoConstraints = false
       return sv
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func layoutUI() {
      backgroundColor = .clear
      scrollView.backgroundColor = .systemGray5
      containerView.backgroundColor = .white
      
      scrollView.addSubview(contentStackView)
      contentView.addSubview(containerView)
      containerView.addSubviews(headerView, scrollView, pageControl)
      
      NSLayoutConstraint.activate([
         containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
         containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         
         headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
         headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
         headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
         headerView.heightAnchor.constraint(equalToConstant: 44),
         
         scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
         scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
         scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
         scrollView.heightAnchor.constraint(equalToConstant: 360),
         
         contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
         contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
         contentStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
         
         pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 18),
         pageControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
         pageControl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4)
      ])
   }
   
   func set(_ model: ThreadsModel) {
      self.model = model
      let subtitle = model.joinCount > 1 ? "\(model.joinCount) others joined" : ""
      headerView.set(title: "Threads", subtitle: subtitle, avatar: nil)
      pageControl.numberOfPages = model.posts.count + 1
      pageControl.currentPage = 0
      
      // Clear existing views
      contentStackView.arrangedSubviews.forEach {
         contentStackView.removeArrangedSubview($0)
         $0.removeFromSuperview()
      }
      threadItemViews.removeAll()
      
      // Add thread item views
      let width = UIScreen.main.bounds.size.width - 32
      
      for post in model.posts {
         let itemView = ThreadItemView()
         itemView.set(post)
         itemView.translatesAutoresizingMaskIntoConstraints = false
         itemView.widthAnchor.constraint(equalToConstant: width).isActive = true
         contentStackView.addArrangedSubview(itemView)
         threadItemViews.append(itemView)
      }
      
      // Add "See More" view
      let seeMoreView = ThreadSeeMoreView()
      seeMoreView.set(profileImages: [
         "https://t4.ftcdn.net/jpg/04/57/50/41/360_F_457504159_nEcxnfFqE9O1jaogLTh4bviUPPQ7xncW.jpg",
         "https://t4.ftcdn.net/jpg/04/57/50/41/360_F_457504159_nEcxnfFqE9O1jaogLTh4bviUPPQ7xncW.jpg",
         "https://t4.ftcdn.net/jpg/04/57/50/41/360_F_457504159_nEcxnfFqE9O1jaogLTh4bviUPPQ7xncW.jpg"
      ])
      seeMoreView.translatesAutoresizingMaskIntoConstraints = false
      seeMoreView.widthAnchor.constraint(equalToConstant: width).isActive = true
      seeMoreView.heightAnchor.constraint(equalToConstant: 164).isActive = true
      contentStackView.addArrangedSubview(seeMoreView)
   }
}

// MARK: - UIScrollViewDelegate
extension ThreadsPostsCell: UIScrollViewDelegate {
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let cellWidth = UIScreen.main.bounds.size.width - 32
      let spacing: CGFloat = 16
      let totalWidth = cellWidth + spacing
      let offsetX = scrollView.contentOffset.x + 16
      let page = Int(round(offsetX / totalWidth))
      pageControl.currentPage = page
   }
   
   func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      let cellWidth = UIScreen.main.bounds.size.width - 32
      let spacing: CGFloat = 16
      let totalWidth = cellWidth + spacing
      
      let targetX = targetContentOffset.pointee.x + 16
      let index = round(targetX / totalWidth)
      let newOffset = index * totalWidth - 16
      
      targetContentOffset.pointee.x = max(newOffset, -16)
   }
}

// MARK: - ThreadItemView (converted from ThreadItemCell)
final class ThreadItemView: UIView {
   
   private let generalStackView = UIStackView()
   private let userInfoStackView = UIStackView()
   
   private lazy var profileImageView: GFAvatarImageView = {
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
   
   private var postImageHeightConstraint: NSLayoutConstraint?
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      configureUserInfoStackView()
      configureGeneralStackView()
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
   
   private func layoutUI() {
       layer.cornerRadius = 16
       backgroundColor = .white
       layer.borderWidth = 1
       layer.borderColor = UIColor.systemGray6.cgColor
       
       addSubview(generalStackView)
       addSubview(moreButton)
       
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
      timeLabel.text = "5h"
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
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
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
   
   private func layoutUI() {
      layer.cornerRadius = 16
      backgroundColor = .white
      layer.borderWidth = 1
      layer.borderColor = UIColor.systemGray6.cgColor
      
      addSubviews(generalStackView)
      
      NSLayoutConstraint.activate([
         generalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
         generalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
         generalStackView.heightAnchor.constraint(equalToConstant: 140)
      ])
   }
}
