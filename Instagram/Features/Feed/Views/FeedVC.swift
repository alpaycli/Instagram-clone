//
//  FeedVC.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

import UIKit

struct StoryResponse {
   let data: [Story]
}

struct Story {
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
      .init()
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
   init(post: Post) {
      
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
//
//struct ThreadsPostModel {
//   let id: String
//   let ownerPhoto, image, text: String
//   let likeCount, commentCount, repostCount, sharedCount: Int
//   let createdAt: Date
//}

struct PeopleSuggestionPostModel {
   init(post: Post) {
      
   }
}

/*
{
   "postType": "normal",
   "id": "n1",
   "username": "ali.k",
   "userPhoto": "https://i.pravatar.cc/80?img=12",
   "location": "Baku, Azerbaijan",
   "images": ["https://picsum.photos/seed/n1a/800/800"],
   "likeCount": 124,
   "likedBy": ["ayse.oz", "mehmet34"],
   "description": "Güzel bir gün ☀ ",
   "createdAt": "2025-09-10T14:23:00.000Z"
}

{
   "postType": "ad",
   "id": "ad1",
   "advertiserName": "BrandX",
   "advertiserPhoto": "https://i.pravatar.cc/80?img=45",
   "image": "https://picsum.photos/seed/ad1/1000/800",
   "shoppingUrl": "https://shop.example.com/product/12345",
   "likeCount": 45,
   "likedBy": ["user1", "user2"],
   "description": "Yeni sezon indirimleri başladı! Kaçırma.",
   "createdAt": "2025-09-09T10:00:00.000Z"
}
{
   "postType": "threads",
   "id": "t1",
   "threadTitle": "Sabah kahvesi sohbeti",
   "joinCount": 256,
   "posts": [
{
   "id": "t1p1",
   "ownerPhoto": "https://i.pravatar.cc/80?img=21",
   "username": "coffee_lover",
   "createdAt": "2025-09-11T07:10:00.000Z",
   "image": "https://picsum.photos/seed/t1p1/600/400",
   "text": null,
   "likeCount": 12,
   "commentCount": 3,
   "repostCount": 1,
   "sharedCount": 0
},
{
   "id": "t1p2",
   "ownerPhoto": "https://i.pravatar.cc/80?img=22",
   "username": "daily.reader",
   "createdAt": "2025-09-11T07:20:00.000Z",
   "image": null,
   "text": "Bugün hangi kitabı önerirsiniz?",
   "likeCount": 34,
   "commentCount": 10,
   "repostCount": 2,
   "sharedCount": 1
}
]
}
{
   "postType": "people_suggestion",
   "id": "ps1",
   "suggestions": [
   { "photo": "https://i.pravatar.cc/80?img=2", "firstName": "Seda", "lastName": "Yılmaz",
   "username": "seda_y" },
   { "photo": "https://i.pravatar.cc/80?img=3", "firstName": "Ozan", "lastName": "Kaya",
   "username": "ozan_k" }
   ]
}

*/

enum PostType {
   case normal(NormalPostModel)
   case ad(AdPostModel)
   case threads(ThreadsModel)
   case peopleSuggestion(PeopleSuggestionPostModel)
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
      Task {
         await viewModel.fetchAllPosts()
      }
      view.backgroundColor = .red
      
      configureCollectionView()
   }
   
   private func configureCollectionView() {
      collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
      view.addSubview(collectionView)
      
      
//      cv.delegate = self
      collectionView.dataSource = self
      collectionView.register(StoryCell.self, forCellWithReuseIdentifier: StoryCell.reuseId)
      collectionView.register(NormalPostCell.self, forCellWithReuseIdentifier: NormalPostCell.reuseId)
      collectionView.register(AdPostCell.self, forCellWithReuseIdentifier: AdPostCell.reuseId)
      collectionView.register(ThreadsPostsCell.self, forCellWithReuseIdentifier: ThreadsPostsCell.reuseID)
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
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCell.reuseId, for: indexPath) as! StoryCell
         default:
            switch viewModel.allPosts[indexPath.item].type {
               case .normal(let model):
                  let c = collectionView.dequeueReusableCell(withReuseIdentifier: NormalPostCell.reuseId, for: indexPath) as! NormalPostCell
                  c.set(model)
                  cell = c
               case .ad(let x):
                  cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdPostCell.reuseId, for: indexPath) as! AdPostCell
               case .threads(let data):
                  let c = collectionView.dequeueReusableCell(withReuseIdentifier: ThreadsPostsCell.reuseID, for: indexPath) as! ThreadsPostsCell
                  c.set(data)
                  cell = c
               case .peopleSuggestion(let x):
                  break
            }
      }

      
      return cell
   }
}

// MARK: - Compositional Layout

extension FeedVC {
   private func createStoriesSection() -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(200))
      
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      group.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 2)
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary 
      
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
   FeedView()
}
