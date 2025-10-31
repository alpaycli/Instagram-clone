import Foundation

// MARK: - Welcome
struct PostResponse: Codable {
    let data: [PostModel]
}

// MARK: - Datum
struct PostModel: Codable {
    let postType: String
    let data: Post
   
   var type: PostType {
      switch postType {
         case "normal": .normal(.init(post: data))
         case "ad": .ad(.init(post: data))
         case "threads": .threads(.init(post: data))
         case "peopleSuggestion": .peopleSuggestion(.init(post: data))
         default: .normal(.init(post: data))
      }
   }
   
   static let sampleModel: Self = .init(postType: "normal", data: Post(id: "id2"))
   static let mockData: [Self] = [
      .init(
         postType: "normal",
         data: .init(likeCount: 120, likedBy: ["mike.s"], description: "Nice post description", username: "cristiano", createdAt: .distantPast, location: "Baku, Azerbaijan")
      ),
      .init(postType: "threads", data: .init(
         id: "id4",
         threadTitle: "Ad description",
         joinCount: 129,
         posts: [
            .init(id: "921391", ownerPhoto: "", username: "ivicazubac", createdAt: .distantPast, image: nil, text: "Salam bu threads textidir", likeCount: 290, commentCount: 15, repostCount: 9, sharedCount: 3),
            .init(id: "221391", ownerPhoto: "", username: "bradley.b", createdAt: .distantPast, image: "https://t4.ftcdn.net/jpg/04/57/50/41/360_F_457504159_nEcxnfFqE9O1jaogLTh4bviUPPQ7xncW.jpg", text: "Salam bu threads textidir", likeCount: 90, commentCount: 15, repostCount: 9, sharedCount: 3),
            .init(id: "2213", ownerPhoto: "", username: "marklall", createdAt: .distantPast, image: "https://files.azedu.az/articles/2024/02/08/96130.jpg", text: "Salam bu threads textidir", likeCount: 20, commentCount: 15, repostCount: 9, sharedCount: 3)
         ]
      )),
      .init(postType: "normal", data:       .init(
         id: "id5",
         description: "One Another post description"
      ))

   ]
}

// MARK: - DataClass
struct Post: Codable {
    let id, advertiserName: String?
    let advertiserPhoto, image: String?
    let shoppingURL: String?
    let likeCount: Int?
    let likedBy: [String]?
    let description, username: String?
   let createdAt: Date?
    let userPhoto: String?
    let location: String?
    let images: [String]?
    let threadTitle: String?
    let joinCount: Int?
    let posts: [ThreadPost]?
    let suggestions: [PeopleSuggestionModel]?

    enum CodingKeys: String, CodingKey {
        case id, advertiserName, advertiserPhoto, image
        case shoppingURL = "shoppingUrl"
        case likeCount, likedBy, description, createdAt, username, userPhoto, location, images, threadTitle, joinCount, posts, suggestions
    }
   
//   init(
//      id: String,
//      username: String? = nil,
//      userPhoto: String? = nil,
//      location: String? = nil,
//      description: String? = nil,
//      createdAt: Date? = nil,
//      advertiserName: String? = nil,
//      images: [String]? = nil,
//      likedBy: [String]? = nil,
//      likeCount: Int? = nil
//   ) {
//      self.id = id
//      self.username = username
//      self.userPhoto = userPhoto
//      self.location = location
//      self.description = description
//      self.createdAt = createdAt
//      self.advertiserName = advertiserName
//      self.images = images
//      self.likedBy = likedBy
//      self.likeCount = likeCount
//   }
   
   init(
      id: String? = nil,
      advertiserName: String? = nil,
      advertiserPhoto: String? = nil,
      image: String? = nil,
      shoppingURL: String? = nil,
      likeCount: Int? = nil,
      likedBy: [String]? = nil,
      description: String? = nil,
      username: String? = nil,
      createdAt: Date? = nil,
      userPhoto: String? = nil,
      location: String? = nil,
      images: [String]? = nil,
      threadTitle: String? = nil,
      joinCount: Int? = nil,
      posts: [ThreadPost]? = nil,
      suggestions: [PeopleSuggestionModel]? = nil
   ) {
      self.id = id
      self.advertiserName = advertiserName
      self.advertiserPhoto = advertiserPhoto
      self.image = image
      self.shoppingURL = shoppingURL
      self.likeCount = likeCount
      self.likedBy = likedBy
      self.description = description
      self.username = username
      self.createdAt = createdAt
      self.userPhoto = userPhoto
      self.location = location
      self.images = images
      self.threadTitle = threadTitle
      self.joinCount = joinCount
      self.posts = posts
      self.suggestions = suggestions
   }
   
   
}

// MARK: - Post
struct ThreadPost: Codable {
    let id: String
    let ownerPhoto: String
   let username: String
   let createdAt: Date?
    let image: String?
    let text: String?
    let likeCount, commentCount, repostCount, sharedCount: Int
   
   init(id: String, ownerPhoto: String, username: String, createdAt: Date?, image: String?, text: String?, likeCount: Int, commentCount: Int, repostCount: Int, sharedCount: Int) {
      self.id = id
      self.ownerPhoto = ownerPhoto
      self.username = username
      self.createdAt = createdAt
      self.image = image
      self.text = text
      self.likeCount = likeCount
      self.commentCount = commentCount
      self.repostCount = repostCount
      self.sharedCount = sharedCount
   }
   
   
/// Mock
   init(
      id: String = "",
      ownerPhoto: String = "",
      username: String = "",
      createdAt: Date? = nil,
      image: String? = "",
      text: String? = "",
      likeCount: Int = 0,
      commentCount: Int = 0,
      repostCount: Int = 0,
   ) {
      self.id = id
      self.ownerPhoto = ownerPhoto
      self.username = username
      self.createdAt = createdAt
      self.image = image
      self.text = text
      self.likeCount = likeCount
      self.commentCount = commentCount
      self.repostCount = repostCount
      self.sharedCount = 0
   }

}

// MARK: - Suggestion
struct PeopleSuggestionModel: Codable {
    let photo: String
    let fullName, username: String
}
