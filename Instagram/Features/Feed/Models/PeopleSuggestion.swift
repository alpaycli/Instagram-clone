//
//  PeopleSuggestion.swift
//  Instagram
//
//  Created by Alpay Calalli on 06.11.25.
//

import Foundation

struct PeopleSuggestion: Codable {
   let fullName, username: String
   let photo: String
}

struct PeopleSuggestionsModel {
   let suggestions: [PeopleSuggestion]
   
   init() { suggestions = [] }
   
   init(post: Post) {
      self.suggestions = post.suggestions ?? []
   }
}
