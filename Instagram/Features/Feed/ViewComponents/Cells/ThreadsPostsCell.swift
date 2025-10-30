import UIKit

final class ThreadsPostsCell: UICollectionViewCell {
   
   static let reuseID = "ThreadsPostsCell"
   
   private var model: ThreadsModel = .init(post: PostModel.mockData[1].data)
   
   private lazy var titleLabel: UILabel = {
      let label = UILabel()
      label.text = "Threads Posts"
      label.font = .boldSystemFont(ofSize: 16)
      label.textColor = .label
      return label
   }()
   
   private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .horizontal
       layout.minimumLineSpacing = 16 // Space between cells
       
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
      configure()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func configure() {
      contentView.backgroundColor = .systemGray5 // Gray background
      
      [titleLabel, collectionView].forEach { contentView.addSubview($0) }
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
         titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
         titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
         
         collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
         collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
      ])
   }
   
   func set(_ model: ThreadsModel) {
      self.model = model
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
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width = collectionView.bounds.width - 32 // Subtract left + right padding
      let height = collectionView.bounds.height
      return CGSize(width: width, height: height)
   }
}

// MARK: - UIScrollViewDelegate (Paging behavior)
extension ThreadsPostsCell: UIScrollViewDelegate {
   func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      let cellWidth = scrollView.bounds.width - 32
      let spacing: CGFloat = 16
      let totalCellWidth = cellWidth + spacing
      
      let targetX = targetContentOffset.pointee.x + 16 // Account for left inset
      let index = round(targetX / totalCellWidth)
      let newOffset = index * totalCellWidth - 16
      
      targetContentOffset.pointee.x = max(newOffset, -16)
   }
}

// MARK: - ThreadItemCell
final class ThreadItemCell: UICollectionViewCell {
   static let reuseID = "ThreadItemCell"
   
   private let profileImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.layer.cornerRadius = 16
      imageView.clipsToBounds = true
      imageView.contentMode = .scaleAspectFill
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
//      imageView.layer.cornerRadius = 10
//      imageView.clipsToBounds = true
      imageView.contentMode = .scaleAspectFit
      imageView.backgroundColor = .clear
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func configure() {
       contentView.layer.cornerRadius = 16
       contentView.backgroundColor = .white // White background
       contentView.layer.borderWidth = 1
       contentView.layer.borderColor = UIColor.systemGray6.cgColor
       
       contentView.addSubview(profileImageView)
       contentView.addSubview(nameLabel)
       contentView.addSubview(timeLabel)
       contentView.addSubview(moreButton)
       contentView.addSubview(descriptionLabel)
       contentView.addSubview(postImageView)
       
       let padding: CGFloat = 16
       
       NSLayoutConstraint.activate([
           profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
           profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
           profileImageView.widthAnchor.constraint(equalToConstant: 32),
           profileImageView.heightAnchor.constraint(equalToConstant: 32),
           
           nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
           nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
           
           timeLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
           timeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5),
           
           moreButton.topAnchor.constraint(equalTo: profileImageView.topAnchor),
           moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
           
           descriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 14),
           descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
           descriptionLabel.trailingAnchor.constraint(equalTo: moreButton.trailingAnchor),
           
           postImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
           postImageView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
           postImageView.trailingAnchor.constraint(equalTo: moreButton.trailingAnchor),
           postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor, multiplier: 0.75), // Aspect ratio
           postImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
       ])
   }
   
   func set(_ post: ThreadPost) {
      // Replace with your actual image loading
      nameLabel.text = post.username
      timeLabel.text = "5h"
      descriptionLabel.text = post.text
      if let imageUrl = post.image {
         postImageView.downloadImage(fromURL: imageUrl)
      }
   }
}
