//
//  FeedVC.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

import UIKit

struct StoryResponse {
   let data: [StoryModel]
}

struct StoryModel {
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
      .init(),
      .init(),
      .init(),
      .init(),
      .init(),
      .init(),
      .init(),
   ]
}

/*
GET /stories
{
"data": [
{
   "username": "ali.k",
   "userPhoto": "https://i.pravatar.cc/100?img=12",
   "storyUrl": "https://picsum.photos/seed/s1/720/1280",
   "isLive": false
},
]
}
 */

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
      self.createdAt = post.createdAt ?? .now
   }
}

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

enum PostType {
   case normal(NormalPostModel)
   case ad(AdPostModel)
   case threads(ThreadsModel)
   case peopleSuggestion(PeopleSuggestionsModel)
}

class FeedVC: UIViewController {
   
   enum Section {
      case stories
      case posts
   }
   private var sections: [Section] = [.stories, .posts]
   
   private let viewModel = FeedViewModel()
   private var collectionView: UICollectionView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      viewModel.output = self
//      Task {
//         await viewModel.fetchAllPosts()
//      }
      
      configureCollectionView()
   }
   
   private func configureCollectionView() {
      collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
      view.addSubview(collectionView)
      
      
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.register(StoriesCell.self, forCellWithReuseIdentifier: StoriesCell.reuseId)
      collectionView.register(StoryItemCell.self, forCellWithReuseIdentifier: StoryItemCell.reuseId)
      collectionView.register(NormalPostCell.self, forCellWithReuseIdentifier: NormalPostCell.reuseId)
      collectionView.register(ThreadsPostsCell.self, forCellWithReuseIdentifier: ThreadsPostsCell.reuseID)
      collectionView.register(PeopleSuggestionCell.self, forCellWithReuseIdentifier: PeopleSuggestionCell.reuseId)
   }
   
   private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
      
      return UICollectionViewCompositionalLayout { [weak self] section, env -> NSCollectionLayoutSection? in
         guard let self else { return nil }
         switch section {
            case 0: return createStoriesSection()
            case 1: return createPostsSection()
            default: return createStoriesSection()
         }
      }
   }
}

extension FeedVC: UICollectionViewDataSource {
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      sections.count
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      switch section {
         case 0: viewModel.allStories.count
         case 1: viewModel.allPosts.count
         default: 0
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      var cell: UICollectionViewCell!
      
      switch indexPath.section {
         case 0:
            let c = collectionView.dequeueReusableCell(withReuseIdentifier: StoryItemCell.reuseId, for: indexPath) as! StoryItemCell
            c.set(viewModel.allStories[indexPath.item])
            cell = c
         default:
            switch viewModel.allPosts[indexPath.item].type {
               case .normal(let data):
                  let c = collectionView.dequeueReusableCell(withReuseIdentifier: NormalPostCell.reuseId, for: indexPath) as! NormalPostCell
                  c.set(data)
                  cell = c
               case .ad(let data):
                  let c = collectionView.dequeueReusableCell(withReuseIdentifier: NormalPostCell.reuseId, for: indexPath) as! NormalPostCell
                  c.set(data)
                  cell = c
               case .threads(let data):
                  let c = collectionView.dequeueReusableCell(withReuseIdentifier: ThreadsPostsCell.reuseID, for: indexPath) as! ThreadsPostsCell
                  c.set(data)
                  cell = c
               case .peopleSuggestion(let data):
                  print("people suggestion cell should appear")
                  let c = collectionView.dequeueReusableCell(withReuseIdentifier: PeopleSuggestionCell.reuseId, for: indexPath) as! PeopleSuggestionCell
                  c.set(data.suggestions)
                  cell = c
            }
      }

      
      return cell
   }
}

extension FeedVC: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      print("viewModel.allPosts[indexPath.item]", viewModel.allPosts[indexPath.item].postType)
      return .zero
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   }
}

// MARK: - Compositional Layout

extension FeedVC {
   private func createStoriesSection() -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(
         widthDimension: .absolute(80),
         heightDimension: .absolute(80)
      )
      
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
//      item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(110))
      
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//      group.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 0)
      group.interItemSpacing = .fixed(10) // 👈 10pt spacing between items
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 0)
      
      return section
   }
   
//   private func createPostsSection() -> NSCollectionLayoutSection {
//      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//      
//      let item = NSCollectionLayoutItem(layoutSize: itemSize)
//      item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//      
//      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.6))
//      
//      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//      group.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 2)
//      
//      let section = NSCollectionLayoutSection(group: group)
//      
//      return section
//   }
   
   func createPostsSection() -> NSCollectionLayoutSection {
       let itemSize = NSCollectionLayoutSize(
           widthDimension: .fractionalWidth(1.0),
           heightDimension: .estimated(400)
       )
       let item = NSCollectionLayoutItem(layoutSize: itemSize)
       
       let groupSize = NSCollectionLayoutSize(
           widthDimension: .fractionalWidth(1.0),
           heightDimension: .estimated(400)
           //            heightDimension: .estimated(bunu 5 qoyanda post cell qalir normal amma o biriler pozulurb. ESLINDE mence threads container viewa fixed height versek duzele biler cox shey. Eynisi threadsin contentViewu ucun de.)
       )
       let group = NSCollectionLayoutGroup.vertical(
           layoutSize: groupSize,
           subitems: [item]
       )
       
       let section = NSCollectionLayoutSection(group: group)
       section.interGroupSpacing = 0
      section.orthogonalScrollingBehavior = .none
       return section
   }
}

extension FeedVC: FeedViewModelOutput {
   func updateView(with characters: [PostModel]) {
      DispatchQueue.main.async {
         self.collectionView.reloadData()
      }
   }
}

import SwiftUI

struct FeedView: UIViewControllerRepresentable{
   func makeUIViewController(context: Context) -> FeedVC {
      FeedVC()
   }
   
   func updateUIViewController(_ uiViewController: FeedVC, context: Context) {
      
   }
}

#Preview {
   FeedVC()
}
