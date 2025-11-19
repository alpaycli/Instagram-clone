//
//  NormalPostModel.swift
//  Instagram
//
//  Created by Alpay Calalli on 06.11.25.
//

import Foundation

struct NormalPostModel: Identifiable {
   let id: String
   let username, description: String
   let userPhoto, location: String?
   let images, likedBy: [String]
   let likeCount: Int
   let createdAt: Date
   
   init(post: Post) {
      self.id = post.id ?? UUID().uuidString
      self.username = post.username ?? "N/A"
      self.userPhoto = post.userPhoto
      self.location = post.location
      self.description = post.description ?? ""
      self.images = post.images ?? []
      self.likedBy = post.likedBy ?? []
      self.likeCount = post.likeCount ?? 0
      if let createdAt = post.createdAt {
         self.createdAt = parseDateFromISO8601(iso8601Date: createdAt) ?? .distantPast
      } else {
         self.createdAt = .distantPast
      }
   }
}
