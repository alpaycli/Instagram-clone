//
//  StoryDataModel.swift
//  Instagram
//
//  Created by Alpay Calalli on 06.11.25.
//

import Foundation

/// This class is for storing/handling states such as `isSeen` of a story.
class StoryDataModel {
   var storyModel: StoryModel
   var isSeen = false
   
   var username: String { storyModel.username ?? "N/A" }
   var storyUrl: String? { storyModel.storyUrl }
   var userPhoto: String? { storyModel.userPhoto }
   var isLive: Bool { storyModel.isLive }
   
   init(storyModel: StoryModel) {
      self.storyModel = storyModel
   }
   
   static let mockData: [StoryDataModel] = StoryModel.mockData.map({ StoryDataModel(storyModel: $0) })
}
