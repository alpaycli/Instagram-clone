//
//  GFAvatarImageView.swift
//  GitHubFollowers
//
//  Created by Alpay Calalli on 08.08.23.
//

import SDWebImage
import UIKit

final class GFAvatarImageView: UIImageView {
    
    private let placeholderImage = UIImage(systemName: "person")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
//        layer.cornerRadius = 10
//        clipsToBounds = true
//        image = placeholderImage
       backgroundColor = .gray
        translatesAutoresizingMaskIntoConstraints = false
    }
        
    func downloadImage(fromURL urlString: String) {
        guard let url = URL(string: urlString) else { return }
        sd_setImage(with: url, placeholderImage: placeholderImage)
    }
}

extension GFAvatarImageView {
    func cancelImageDownload() {
       sd_cancelCurrentImageLoad()
    }
}

import JSRingView

class ContainerView: UIView {
   
   override init(frame: CGRect) {
      super.init(frame: frame)
//      backgroundColor = .yellow
      
//      let imageView = GFAvatarImageView(frame: .zero)
//      imageView.downloadImage(fromURL: "https://picsum.photos/200")
//      addSubview(imageView)
//      imageView.translatesAutoresizingMaskIntoConstraints = false
//      NSLayoutConstraint.activate([
//         imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//         imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
//         imageView.heightAnchor.constraint(equalToConstant: 164),
//         imageView.widthAnchor.constraint(equalToConstant: 164),
//      ])
//      
//      let ringView = OutsideBorderView()
//      addSubview(ringView)
//      ringView.translatesAutoresizingMaskIntoConstraints = false
//      NSLayoutConstraint.activate([
//         ringView.centerXAnchor.constraint(equalTo: centerXAnchor),
//         ringView.centerYAnchor.constraint(equalTo: centerYAnchor),
//         ringView.heightAnchor.constraint(equalToConstant: 194),
//         ringView.widthAnchor.constraint(equalToConstant: 194),
//      ])
//      ringView.startAnimating()
      let ringView = JSRingView()
      addSubview(ringView)
      ringView.frame = .init(x: 100, y: 100, width: 164, height: 164)
//      ringView.startAnimating()
      
      
//      ringView.backgroundColor = .red
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

#Preview {
   let v = PostCell()
   v.set(
      profileImageUrl: "",
      name: "alpaycli",
      location: "Crocusoft",
      postImageUrl: "",
      likedBy: "albert_l",
      likeCount: 124,
      description: " I'm happy to share that I have started a new position as iOS Developer Intern at Crocusoft!",
      postDateLabel: .distantPast
   )
   
   return v
}

#Preview {
   ContainerView()
}
