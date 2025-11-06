//
//  ThreadsModel.swift
//  Instagram
//
//  Created by Alpay Calalli on 06.11.25.
//

import Foundation

struct ThreadsModel {
   let id: String
   let joinCount: Int
   let posts: [ThreadPost]
   init(post: Post) {
      self.id = post.id ?? "N/A"
      self.joinCount = post.joinCount ?? 0
      self.posts = post.posts ?? []
   }
}

struct ThreadPost: Codable {
   let id: String
   let ownerPhoto: String
   let username: String
   let createdAt: Date?
   let image: String?
   let text: String?
   let likeCount, commentCount, repostCount, sharedCount: Int
   
   init(id: String, ownerPhoto: String, username: String, createdAt: Date?, image: String?, text: String?, likeCount: Int, commentCount: Int, repostCount: Int, sharedCount: Int) {
      self.id = id
      self.ownerPhoto = ownerPhoto
      self.username = username
      self.createdAt = createdAt
      self.image = image
      self.text = text
      self.likeCount = likeCount
      self.commentCount = commentCount
      self.repostCount = repostCount
      self.sharedCount = sharedCount
   }
   
   
   /// Mock
   init(
      id: String = "",
      ownerPhoto: String = "",
      username: String = "",
      createdAt: Date? = nil,
      image: String? = "",
      text: String? = "",
      likeCount: Int = 0,
      commentCount: Int = 0,
      repostCount: Int = 0,
   ) {
      self.id = id
      self.ownerPhoto = ownerPhoto
      self.username = username
      self.createdAt = createdAt
      self.image = image
      self.text = text
      self.likeCount = likeCount
      self.commentCount = commentCount
      self.repostCount = repostCount
      self.sharedCount = 0
   }
   
}
