//
//  ThreadsPostsCell.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

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
      setupUI()
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func setupUI() {
      backgroundColor = .clear
      scrollView.backgroundColor = .systemGray5
      containerView.backgroundColor = .white
      
      scrollView.addSubview(contentStackView)
      contentView.addSubview(containerView)
      containerView.addSubviews(headerView, scrollView, pageControl)
   }
   
   private func layoutUI() {
      NSLayoutConstraint.activate([
         containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
         containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         
         headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
         headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
         headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
         headerView.heightAnchor.constraint(equalToConstant: 48),
         
         scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 6),
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
