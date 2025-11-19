//
//  StoriesPreviewVC.swift
//  Instagram
//
//  Created by Alpay Calalli on 05.11.25.
//

import UIKit

protocol StoriesPreviewViewModelOutput: AnyObject {
   func timerUpdated()
   func showNextStory(withIndex index: Int, stories: [StoryDataModel])
   func showPreviousStory(withIndex index: Int, stories: [StoryDataModel])
   func close()
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
      let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24))
      let image = UIImage(systemName: "xmark", withConfiguration: symbolConfig)
      
      btn.setImage(image, for: .normal)
      btn.tintColor = .white
      btn.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
      
      btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
   }()
   
   @objc func closeButtonTapped() {
//      navigationController?.popToRootViewController(animated: true)
      navigationController?.dismiss(animated: true)
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
      if let url = viewModel.currentStory?.userPhoto {
         imageView.downloadImage(fromURL: url)
      }
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
      let longPressGesture = UILongPressGestureRecognizer(target: viewModel.self, action: #selector(viewModel.leftSideOfScreenLongPressed))
      v.addGestureRecognizer(gesture)
      v.addGestureRecognizer(longPressGesture)
      
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
      let v = GFAvatarImageView(frame: .zero)
      if let url = viewModel.currentStory?.storyUrl {
         v.downloadImage(fromURL: url)
      }
      v.contentMode = .scaleAspectFill
      
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
   }()
   
   private lazy var bottomBarView: StoryBottomBarView = {
      let v = StoryBottomBarView()
      v.beginEditing =  {
         self.viewModel.timer?.invalidate()
      }
      v.endEditing = {
         self.viewModel.configureStoryTimer()
      }
      
      v.translatesAutoresizingMaskIntoConstraints = false
      return v
   }()
   
   init(stories: [StoryDataModel], index: Int) {
      self.viewModel = .init(stories: stories, currentStoryIndex: index)
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      viewModel.output = self
      configureStackView()
      layoutUI()
      viewModel.configureStoryTimer()
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
      
   private lazy var generalStackView: UIStackView = {
      let sv = UIStackView()
      sv.axis = .vertical
      sv.alignment = .center
      
      sv.translatesAutoresizingMaskIntoConstraints = false
      return sv
   }()
   
   private func configureStackView() {
      view.addSubview(generalStackView)
      generalStackView.addArrangedSubview(imageView)
      generalStackView.addArrangedSubview(bottomBarView)
      
      bottomBarView.heightAnchor.constraint(equalToConstant: 78).isActive = true
      bottomBarView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
      
      generalStackView.distribution = .fill
   }
   
   private func layoutUI() {
      view.addSubviews(progressBarView, userInfoStackView, closeButton, /*imageView, bottomBarView*/)
      view.addSubviews(leftHalfOfScreen, rightHalfOfScreen)
      
      generalStackView.backgroundColor = .black
      
      NSLayoutConstraint.activate([
         progressBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
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

         /*
         bottomBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
         bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         bottomBarView.heightAnchor.constraint(equalToConstant: 50),
         
         imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
          */
         
         generalStackView.topAnchor.constraint(equalTo: view.topAnchor),
         generalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         generalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         generalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
      ])
      view.bringSubviewsToFront(progressBarView, userInfoStackView, closeButton)
      
//      bottomBarView.backgroundColor = .green
   }
}

extension StoriesPreviewVC: StoriesPreviewViewModelOutput {
   
   func timerUpdated() {
      if self.progressBarView.progress < 1 {
         self.progressBarView.setProgress(self.progressBarView.progress + 0.01, animated: true)
         
      } else {
         self.viewModel.handleForwardAction()
         viewModel.timer?.invalidate()
      }
   }
   
   func showNextStory(withIndex index: Int, stories: [StoryDataModel]) {
      let destinationVC = StoriesPreviewVC(stories: stories, index: index)
      
      let transition = CATransition()
      transition.duration = 0.3
      transition.type = .push
      transition.subtype = .fromRight
      transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
      navigationController?.view.layer.add(transition, forKey: kCATransition)
      navigationController?.pushViewController(destinationVC, animated: true)
      destinationVC.view.isUserInteractionEnabled = false
      
      // prevent consecutive, bad looking navigations
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
         destinationVC.view.isUserInteractionEnabled = true
      }
   }
   
   func showPreviousStory(withIndex index: Int, stories: [StoryDataModel]) {
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
//      navigationController?.popToRootViewController(animated: true)
      dismiss(animated: true)
   }
}
