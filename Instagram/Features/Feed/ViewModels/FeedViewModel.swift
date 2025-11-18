//
//  FeedViewModel.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

import Foundation

// date -> string
// story bug
// story xbutton
// post profile photo corner radius
// combine

protocol FeedViewModelOutput: AnyObject {
   func updateView()
}

class FeedViewModel {
   weak var output: FeedViewModelOutput?
   
   private(set) var allStories: [StoryDataModel] = StoryDataModel.mockData
   private(set) var allPosts: [PostModel] = PostModel.mockData
   
   private let networkManager = NetworkManager.shared
   
   func fetchAllPosts() async {
      let urlString = "http://172.20.10.179:3000/feed"
      guard let url = URL(string: urlString) else { return }
      
      var urlRequest = URLRequest(url: url)
      urlRequest.timeoutInterval = 20
      
      do {
         let response = try await networkManager.fetch(PostResponse.self, url: urlRequest)
         let result = response.data
         allPosts = result
         output?.updateView()
      } catch {
         print("Error with network request", error.localizedDescription)
      }
      
      
   }
   
   func fetchAllStories() async {
      let urlString = "http://172.20.10.179:3000/stories"
      guard let url = URL(string: urlString) else { return }
      
      var urlRequest = URLRequest(url: url)
      urlRequest.timeoutInterval = 20
      
      do {
         let response = try await networkManager.fetch(StoryResponse.self, url: urlRequest)
         let result = response.data
         allStories = result.map({ StoryDataModel(storyModel: $0) })
         output?.updateView()
         
         let yourStory = StoryDataModel(
            storyModel: .init(
               username: .init(localized: "Your Story"),
               userPhoto: nil,
               storyUrl: nil,
               isLive: false
            )
         )
         allStories.insert(yourStory, at: 0)
      } catch {
         print("Error with network request", error.localizedDescription)
      }
   }
}
