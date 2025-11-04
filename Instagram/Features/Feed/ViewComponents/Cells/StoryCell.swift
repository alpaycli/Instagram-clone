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
      
      return button
  }()

//   private lazy var button: UIView = {
//      let button = UIView()
//      button.backgroundColor = .black
////      button.frame = CGRect(origin: CGPoint(x: center.x - 50 / 2.0, y: center.y - 50 / 2.0), size: CGSize(width: 50, height: 50))
////      button.condition = .init(
////         display: .unseen,
////         color: .custom(
////            colors: [
////               .init(hexString: "#FBAA47"),
////               .init(hexString: "#D91A46"),
////               .init(hexString: "#A60F93"),
////            ]
////         )
////      )
//      
////      button.addTarget(self, action: #selector(storyTapped), for: .touchUpInside)
//      button.isUserInteractionEnabled = true
//      
//      return button
//  }()
   
   private lazy var username: IGTitleLabel = {
      let l = IGTitleLabel(textAlignment: .center, fontSize: 12, weight: .regular)
      
      return l
   }()
   
   var onNavigation: (() -> Void) = {}
   
   override init(frame: CGRect) {
      super.init(frame: frame)
//      heightAnchor.constraint(equalToConstant: 80).isActive = true
//      widthAnchor.constraint(equalToConstant: 80).isActive = true
      
      addSubviews(button, username)
      button.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         button.topAnchor.constraint(equalTo: topAnchor),
         button.leadingAnchor.constraint(equalTo: leadingAnchor),
         button.heightAnchor.constraint(equalToConstant: 62),
         button.widthAnchor.constraint(equalToConstant: 62),
         
         username.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 5),
         username.centerXAnchor.constraint(equalTo: button.centerXAnchor),
         username.heightAnchor.constraint(equalToConstant: 24)
      ])
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func set(_ story: StoryModel) {
      username.text = story.username
      
      if let imageUrl = story.userPhoto {
         loadImage(from: imageUrl) { [weak self] image in
//            self?.button.setImage(image, for: .normal)
         }
      }
   }
}

extension StoryItemCell: IGStoryButtonDelegate {
   func didLongPressed() {}
   
   func didTapped() {
      button.startAnimating()
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
          self?.button.condition = .init(display: .seen)
          self?.button.stopAnimating()
         self?.onNavigation()
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



class StoriesPreviewVC: UIViewController {
   
   private let viewModel: StoriesPreviewViewModel
   
   private lazy var progressBarView: UIProgressView = {
      let v = UIProgressView()
      v.translatesAutoresizingMaskIntoConstraints = false
      v.progressTintColor = .white
      v.trackTintColor = .systemGray
      v.progress = 0
      
      return v
   }()
   
   private lazy var closeButton: UIButton = {
      let btn = UIButton()
      let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 32))
      let image = UIImage(systemName: "xmark", withConfiguration: symbolConfig)

      btn.setImage(image, for: .normal)
      btn.tintColor = .white
      btn.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
      
      btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
   }()
   
   @objc func closeButtonTapped() {
      navigationController?.popToRootViewController(animated: true)
   }
      
   private lazy var userInfoStackView: UIStackView = {
      let sv = UIStackView()
      sv.addArrangedSubview(profileImageView)
      sv.addArrangedSubview(nameLabel)
      sv.addArrangedSubview(timeLabel)
      
      NSLayoutConstraint.activate([
         profileImageView.heightAnchor.constraint(equalToConstant: 32),
         profileImageView.widthAnchor.constraint(equalToConstant: 32),
      ])
      
      sv.axis = .horizontal
      sv.spacing = 10
      sv.alignment = .center
      
      sv.translatesAutoresizingMaskIntoConstraints = false
      return sv
   }()
   
   private lazy var profileImageView: GFAvatarImageView = {
      let imageView = GFAvatarImageView(frame: .zero)
      imageView.layer.cornerRadius = 16
      imageView.clipsToBounds = true
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
   }()
   
   private lazy var nameLabel: IGTitleLabel = {
      let l = IGTitleLabel(textAlignment: .left, fontSize: 14, weight: .semibold)
      l.text = viewModel.currentStory?.username
      l.textColor = .white
      return l
   }()
   
   private lazy var timeLabel: IGSecondaryTitleLabel = {
      let l = IGSecondaryTitleLabel(alignment: .left, fontSize: 13)
      l.text = "4h"
      l.textColor = .secondaryLabel
      return l
   }()
   
   private lazy var leftHalfOfScreen: UIView = {
      let v = UIView()
      v.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height)
      v.backgroundColor = .clear
      
      let gesture = UITapGestureRecognizer(target: viewModel.self, action: #selector(viewModel.leftSideOfScreenTapped))
      v.addGestureRecognizer(gesture)
      
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
      
   }()

   private lazy var rightHalfOfScreen: UIView = {
      let v = UIView()
      v.frame = .init(x: UIScreen.main.bounds.width / 2, y: 0, width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height)
      v.backgroundColor = .clear
      
      let gesture = UITapGestureRecognizer(target: viewModel.self, action: #selector(viewModel.rightSideOfScreenTapped))
      v.addGestureRecognizer(gesture)
      
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
      
   }()
      
   private lazy var imageView: GFAvatarImageView = {
      let v = GFAvatarImageView(frame: view.bounds)
      if let url = viewModel.currentStory?.storyUrl {
         v.downloadImage(fromURL: url)
      }

      
      return v
   }()
   
   init(stories: [StoryClassModel], index: Int) {
      self.viewModel = .init(stories: stories, currentStoryIndex: index)
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      viewModel.output = self
      layoutUI()
      configureStoryTimer()
   }
   
   func configureStoryTimer() {
      viewModel.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
           // 5 seconds total / 0.05 interval = 100 ticks → each tick should add 1/100 = 0.01
           if self.progressBarView.progress < 1 {
              self.progressBarView.setProgress(self.progressBarView.progress + 0.01, animated: true)
              
           } else {
               self.viewModel.handleForwardAction()
               timer.invalidate()
           }
       }
   }

   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       // Hide the navigation bar when this view controller appears
       self.navigationController?.setNavigationBarHidden(true, animated: animated)
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       // Show the navigation bar again when this view controller disappears
       // This is important if you want the navigation bar to reappear in other view controllers
       self.navigationController?.setNavigationBarHidden(false, animated: animated)
   }
   
   private func layoutUI() {
      view.addSubviews(progressBarView, userInfoStackView, closeButton, imageView, leftHalfOfScreen, rightHalfOfScreen)
      
      NSLayoutConstraint.activate([
         progressBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
         progressBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
         progressBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
         progressBarView.heightAnchor.constraint(equalToConstant: 3),
         
         userInfoStackView.topAnchor.constraint(equalTo: progressBarView.bottomAnchor, constant: 18),
         userInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
         userInfoStackView.heightAnchor.constraint(equalToConstant: 32),
         
         
         closeButton.topAnchor.constraint(equalTo: progressBarView.bottomAnchor, constant: 18),
         closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
         closeButton.heightAnchor.constraint(equalToConstant: 32),
         closeButton.widthAnchor.constraint(equalToConstant: 32),
         
      ])
      view.bringSubviewsToFront(progressBarView, userInfoStackView, closeButton)
   }
}

extension StoriesPreviewVC: StoriesPreviewViewModelOutput {
   func showNextStory(withIndex index: Int, stories: [StoryClassModel]) {
      let vc = StoriesPreviewVC(stories: stories, index: index)
      
      let transition = CATransition()
      transition.duration = 0.3
      transition.type = .push
      transition.subtype = .fromRight
      transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
      navigationController?.view.layer.add(transition, forKey: kCATransition)
      navigationController?.pushViewController(vc, animated: true)

   }
   
   func showPreviousStory(withIndex index: Int, stories: [StoryClassModel]) {
      let vc = StoriesPreviewVC(stories: stories, index: index)
      
      let transition = CATransition()
      transition.duration = 0.3
      transition.type = .push
      transition.subtype = .fromLeft
      transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
      navigationController?.view.layer.add(transition, forKey: kCATransition)
      navigationController?.pushViewController(vc, animated: true)
   }
   
   func close() {
      navigationController?.popToRootViewController(animated: true)
   }
   
   
}

protocol StoriesPreviewViewModelOutput: AnyObject {
    func showNextStory(withIndex index: Int, stories: [StoryClassModel])
   func showPreviousStory(withIndex index: Int, stories: [StoryClassModel])
   func close()
}

class StoriesPreviewViewModel {
   private var currentStoryIndex: Int
   private var stories: [StoryClassModel]
   
   /// To control story duration
   var timer: Timer?
   
   var currentStory: StoryModel? {
      stories[currentStoryIndex].storyModel
   }
   
   weak var output: StoriesPreviewViewModelOutput?
   
   init(stories: [StoryClassModel], currentStoryIndex: Int) {
      self.stories = stories
      self.currentStoryIndex = currentStoryIndex
   }
   
   func handleForwardAction() {
      timer?.invalidate()
      guard currentStoryIndex + 1 < stories.count else {
         output?.close()
         return
      }
      
      currentStoryIndex += 1
      output?.showNextStory(withIndex: currentStoryIndex, stories: stories)
      
      stories[currentStoryIndex].isSeen = true
   }
   
   @objc func leftSideOfScreenTapped() {
      timer?.invalidate()
      guard currentStoryIndex > 0 else { return }
      
     currentStoryIndex -= 1
      output?.showPreviousStory(withIndex: currentStoryIndex, stories: stories)
      
      stories[currentStoryIndex].isSeen = true
   }
   
   @objc func rightSideOfScreenTapped() {
      handleForwardAction()
   }
}

#Preview {
   let vc = StoriesPreviewVC(
      stories: StoryModel.mockData.map({StoryClassModel(storyModel: $0) }),
      index: 0
   )
   let navcontroll = UINavigationController(rootViewController: vc)
   
   return navcontroll
}
