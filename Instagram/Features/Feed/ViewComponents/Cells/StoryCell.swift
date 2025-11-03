//
//  StoryCell.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

import UIKit

class StoriesCell: UICollectionViewCell {
   static let reuseId = "StoriesCell"
   
   private var stories: [StoryModel] = []
   
   private lazy var collectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.minimumLineSpacing = 5
//      let width = UIScreen.main.bounds.size.width / 2.5
//     layout.estimatedItemSize = CGSize(width: width, height: 10)

      let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
      cv.backgroundColor = .clear
      cv.showsHorizontalScrollIndicator = false
      cv.dataSource = self
      cv.delegate = self
      cv.isScrollEnabled = true
//      cv.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
      cv.register(StoryItemCell.self, forCellWithReuseIdentifier: StoryItemCell.reuseId)
      
      cv.translatesAutoresizingMaskIntoConstraints = false
      return cv
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      layer.cornerRadius = 24
//      backgroundColor = .red
      
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func set(_ stories: [StoryModel]) {
      self.stories = stories
      collectionView.reloadData()
   }
   
   private func layoutUI() {
      contentView.addSubviews(collectionView)
      
      NSLayoutConstraint.activate([
         collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
         collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
         collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
         collectionView.heightAnchor.constraint(equalToConstant: 90),
      ])
   }
}

extension StoriesCell: UICollectionViewDataSource {
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      stories.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let item = stories[indexPath.item]
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryItemCell.reuseId, for: indexPath) as! StoryItemCell
      cell.set(item)
      
      return cell

   }
}

extension StoriesCell: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      print(indexPath.item)
   }
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width = collectionView.bounds.width / 4
      let height = collectionView.bounds.height
      return CGSize(width: width, height: height)
   }
}

import IGStoryButtonKit

class StoryItemCell: UICollectionViewCell {
   static let reuseId = "StoryItemCell"
   
   private lazy var button: IGStoryButton = {
      let button = IGStoryButton()
//      button.frame = CGRect(origin: CGPoint(x: center.x - 50 / 2.0, y: center.y - 50 / 2.0), size: CGSize(width: 50, height: 50))
      button.condition = .init(
         display: .unseen,
         color: .custom(
            colors: [
               .init(hexString: "#FBAA47"),
               .init(hexString: "#D91A46"),
               .init(hexString: "#A60F93"),
            ]
         )
      )
      return button
  }()

   
   override init(frame: CGRect) {
      super.init(frame: frame)
//      heightAnchor.constraint(equalToConstant: 80).isActive = true
//      widthAnchor.constraint(equalToConstant: 80).isActive = true
      
      addSubview(button)
      button.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         button.topAnchor.constraint(equalTo: topAnchor),
         button.leadingAnchor.constraint(equalTo: leadingAnchor),
         
         button.heightAnchor.constraint(equalToConstant: 62),
         button.widthAnchor.constraint(equalToConstant: 62),
      ])
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func set(_ story: StoryModel) {
      if let imageUrl = story.userPhoto {
         loadImage(from: imageUrl) { [weak self] image in
            self?.button.image = image
         }
      }
   }
}

func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error downloading image: \(error.localizedDescription)")
            completion(nil)
            return
        }

        guard let data = data else {
            print("No image data received")
            completion(nil)
            return
        }

        // Create UIImage on the main thread
        DispatchQueue.main.async {
            let image = UIImage(data: data)
            completion(image)
        }
    }.resume()
}
