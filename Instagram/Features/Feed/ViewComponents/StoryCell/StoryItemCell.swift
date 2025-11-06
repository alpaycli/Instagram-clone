//
//  StoryItemCell.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

import UIKit

class StoryItemCell: UICollectionViewCell {
   static let reuseId = "StoryItemCell"
   
   private lazy var button: IGStoryButton = {
      let button = IGStoryButton()
      button.backgroundColor = .black
      button.frame = CGRect(origin: CGPoint(x: center.x - 50 / 2.0, y: center.y - 50 / 2.0), size: CGSize(width: 50, height: 50))
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
      
      button.delegate = self
      
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
   }()
   
   private lazy var liveIndicatorView: StoryLiveIndicatorView = {
      let v = StoryLiveIndicatorView()
      
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
   }()
   
   private lazy var usernameLabel: IGTitleLabel = {
      let l = IGTitleLabel(textAlignment: .center, fontSize: 12, weight: .regular)
      
      return l
   }()
   
   var onStoryTapped: (() -> Void) = {}
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      layoutUI()
   }
   
   override func prepareForReuse() {
      super.prepareForReuse()
      button.image = nil
      button.condition = .init(display: .none)
      
      usernameLabel.text = nil
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func set(_ story: StoryDataModel) {
      usernameLabel.text = story.username
      layoutLiveIndicatorViewIfNeeded(isLive: story.isLive)
      button.condition = .init(display: story.isSeen ? .seen : .unseen)
      
      if let imageUrl = story.userPhoto {
         loadImage(from: imageUrl) { [weak self] image in
            self?.button.image = image
         }
      }
   }
   
   private func layoutUI() {
      addSubviews(button, usernameLabel)
      NSLayoutConstraint.activate([
         button.topAnchor.constraint(equalTo: topAnchor),
         button.leadingAnchor.constraint(equalTo: leadingAnchor),
         button.heightAnchor.constraint(equalToConstant: 62),
         button.widthAnchor.constraint(equalToConstant: 62),
         
         usernameLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 5),
         usernameLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor),
         usernameLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor),
         usernameLabel.heightAnchor.constraint(equalToConstant: 24),
      ])
      
   }
   
   private func layoutLiveIndicatorViewIfNeeded(isLive: Bool) {
      guard isLive else { return }
      
      addSubview(liveIndicatorView)
      NSLayoutConstraint.activate([
         liveIndicatorView.centerYAnchor.constraint(equalTo: button.bottomAnchor, constant: 4),
         liveIndicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
         liveIndicatorView.heightAnchor.constraint(equalToConstant: 16),
         liveIndicatorView.widthAnchor.constraint(equalToConstant: 26),
      ])
      bringSubviewToFront(liveIndicatorView)
   }
}

extension StoryItemCell: IGStoryButtonDelegate {
   func didLongPressed() {}
   
   func didTapped() {
      button.condition = .init(display: .seen)
      onStoryTapped()
   }
}

extension StoryItemCell {
   private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
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
         
         DispatchQueue.main.async {
            let image = UIImage(data: data)
            completion(image)
         }
      }.resume()
   }
}
