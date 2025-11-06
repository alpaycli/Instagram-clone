//
//  ThreadReactionsView.swift
//  Instagram
//
//  Created by Alpay Calalli on 30.10.25.
//

import UIKit

class ThreadReactionsView: UIView {
   
   private lazy var stackView: UIStackView = {
      let sv = UIStackView()
      sv.axis = .horizontal
      sv.spacing = 15
      sv.alignment = .leading
      //      stackView.distribution = .fill
      
      [likeItemView, commentItemView, repostItemView, shareItemView]
         .forEach({ sv.addArrangedSubview($0) })
      
      sv.translatesAutoresizingMaskIntoConstraints = false
      return sv
   }()
   
   private var likeItemView = ThreadReactionItemView()
   private var commentItemView = ThreadReactionItemView()
   private var repostItemView = ThreadReactionItemView()
   private var shareItemView = ThreadReactionItemView()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func set(_ postData: ThreadPost) {
      likeItemView.set(image: PostActionIcon.like, label: "\(postData.likeCount)", buttonAction: {print("like tapped")})
      commentItemView.set(image: PostActionIcon.comment, label: "\(postData.commentCount)", buttonAction: {print("comment tapped")})
      repostItemView.set(image: PostActionIcon.repost, label: "\(postData.repostCount)", buttonAction: {print("repost tapped")})
      shareItemView.set(image: PostActionIcon.share, label: "\(postData.sharedCount)", buttonAction: {print("share tapped")})
   }
   
   private func layoutUI() {
      addSubview(stackView)
      NSLayoutConstraint.activate([
         stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
         stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
         stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
         stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
      ])
   }
   
   
}
