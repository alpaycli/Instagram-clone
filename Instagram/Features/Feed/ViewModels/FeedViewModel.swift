//
//  FeedViewModel.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

import Foundation

protocol FeedViewModelOutput: AnyObject {
   func updateView(with characters: [PostModel])
}

class FeedViewModel {
   weak var output: FeedViewModelOutput?
   
   private(set) var allStories: [Story] = Story.mockData
   private(set) var allPosts: [PostModel] = PostModel.mockData
   
   private let networkManager = NetworkManager.shared
   
   func fetchAllPosts() async {
      let urlString = "http://172.20.10.179:3000/feed"
      guard let url = URL(string: urlString) else { return }
      
      var urlRequest = URLRequest(url: url)
      urlRequest.timeoutInterval = 120
      
//      isLoadingCharacters = true
      do {
         let response = try await networkManager.fetch(PostResponse.self, url: urlRequest)
         let result = response.data
         print(response.data.count)
         allPosts = result
         output?.updateView(with: allPosts)
//         isLoadingCharacters = false
      } catch {
         print("Error", error.localizedDescription)
//         isLoadingCharacters = false
      }
      
      
   }
}
