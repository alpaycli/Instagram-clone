//
//  ThreadReactionsView.swift
//  Instagram
//
//  Created by Alpay Calalli on 30.10.25.
//

import UIKit

class ThreadReactionsView: UIView {
   
   private var stackView = UIStackView()
   private var likeItemView = ThreadReactionItemView()
   private var commentItemView = ThreadReactionItemView()
   private var repostItemView = ThreadReactionItemView()
   private var shareItemView = ThreadReactionItemView()

   override init(frame: CGRect) {
       super.init(frame: frame)
       configure()
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
   
   private func configure() {
      stackView.axis = .horizontal
      stackView.spacing = 15
      stackView.alignment = .leading
//      stackView.distribution = .fill
      addSubview(stackView)
      
      [likeItemView, commentItemView, repostItemView, shareItemView]
         .forEach({ stackView.addArrangedSubview($0) })
      
      stackView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
         stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
         stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
//         stackView.heightAnchor.constraint(equalToConstant: 40),
         stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)

      ])
   }
   
   
}

import SwiftUI
struct ThreadReactionsViewRepr: UIViewRepresentable {
   func makeUIView(context: Context) -> ThreadReactionsView {
      let v = ThreadReactionsView()
//      v.set(PostModel.sampleModel.data.posts![1])
      return v
   }
   
   func updateUIView(_ uiView: ThreadReactionsView, context: Context) {
      
   }
}

#Preview {
   ThreadReactionsViewRepr()
}
