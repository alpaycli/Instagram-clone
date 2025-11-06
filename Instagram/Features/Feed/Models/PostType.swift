//
//  PostType.swift
//  Instagram
//
//  Created by Alpay Calalli on 06.11.25.
//

import Foundation

enum PostType {
   case normal(NormalPostModel)
   case ad(AdPostModel)
   case threads(ThreadsModel)
   case peopleSuggestion(PeopleSuggestionsModel)
}
