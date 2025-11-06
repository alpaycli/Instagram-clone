//
//  StoryResponse.swift
//  Instagram
//
//  Created by Alpay Calalli on 06.11.25.
//

import Foundation

struct StoryResponse: Codable {
   let data: [StoryModel]
}

/// Do not use in UI or other players, and only use for decoding purposes.
struct StoryModel: Codable {
   let username, userPhoto, storyUrl: String?
   let isLive: Bool
   
   init(
      username: String? = nil,
      userPhoto: String? = nil,
      storyUrl: String? = nil,
      isLive: Bool = false
   ) {
      self.username = username
      self.userPhoto = userPhoto
      self.storyUrl = storyUrl
      self.isLive = isLive
   }
   
   static let sampleData: Self = .init()
   static let mockData: [Self] = [
      .init(username: "Your Story", userPhoto: "https://picsum.photos/seed/baku1/720/1280" , storyUrl: "https://picsum.photos/seed/baku1/720/1280"),
      .init(username: "cristiano", storyUrl: "https://picsum.photos/seed/baku1/720/1280"),
      .init(username: "messi", userPhoto: "https://picsum.photos/seed/baku1/720/1280"),
      .init(),
      .init(username: "cristiano", storyUrl: "https://picsum.photos/seed/baku1/720/1280"),
      .init(),
      .init(),
      .init(),
      .init(),
   ]
}
