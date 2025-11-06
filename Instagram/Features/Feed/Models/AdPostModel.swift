//
//  AdPostModel.swift
//  Instagram
//
//  Created by Alpay Calalli on 06.11.25.
//

import Foundation

struct AdPostModel {
   let id: String
   let advertiserName, description: String
   let advertiserPhoto, image, shoppingUrl: String?
   let likeCount: Int
   let likedBy: [String]
   let createdAt: Date
   init(post: Post) {
      self.id = post.id ?? UUID().uuidString
      self.advertiserName = post.advertiserName ?? "N/A"
      self.advertiserPhoto = post.advertiserPhoto
      self.description = post.description ?? ""
      self.image = post.image
      self.shoppingUrl = post.shoppingURL
      self.likeCount = post.likeCount ?? 0
      self.likedBy = post.likedBy ?? []
      self.createdAt = post.createdAt ?? .now
   }
}
