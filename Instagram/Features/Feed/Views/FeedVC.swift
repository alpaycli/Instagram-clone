//
//  FeedVC.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

import UIKit

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
      setupViewModel()
      configureNavigationBar()
      configureCollectionView()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      collectionView.reloadData()
   }
   
   private func configureNavigationBar() {
      let logoImageView = UIImageView(image: NavBarIcon.instaLogo)
      logoImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 26)
      
      let dmNavButton = UIBarButtonItem(image: PostActionIcon.share, style: .plain, target: self, action: #selector(navBarDmButtonTapped))
      let igTvButton = UIBarButtonItem(image: NavBarIcon.igTv.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(navBarIgTvButtonTapped))
      
      let cameraButton = UIBarButtonItem(image: .init(systemName: "camera"), style: .plain, target: self, action: #selector(navBarCameraButtonTapped))
      
      dmNavButton.tintColor = .label
      igTvButton.tintColor = .label
      cameraButton.tintColor = .label
      
      navigationItem.titleView = logoImageView
      navigationItem.rightBarButtonItems = [igTvButton, dmNavButton]
      navigationItem.leftBarButtonItem = cameraButton
   }
   
   private func setupViewModel() {
      viewModel.output = self
      Task {
         await viewModel.fetchAllPosts()
         await viewModel.fetchAllStories()
      }
   }
   
   private func configureCollectionView() {
      collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
      view.addSubview(collectionView)
      
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.register(StoryItemCell.self, forCellWithReuseIdentifier: StoryItemCell.reuseId)
      collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseId)
      collectionView.register(ThreadsPostsCell.self, forCellWithReuseIdentifier: ThreadsPostsCell.reuseID)
      collectionView.register(PeopleSuggestionCell.self, forCellWithReuseIdentifier: PeopleSuggestionCell.reuseId)
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
            c.onStoryTapped = {
               self.viewModel.allStories[indexPath.item].isSeen = true
               let vc = StoriesPreviewVC(stories: self.viewModel.allStories, index: indexPath.row)
               self.navigationController?.pushViewController(vc, animated: true)
            }
            cell = c
         default:
            switch viewModel.allPosts[indexPath.item].type {
               case .normal(let data):
                  let c = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseId, for: indexPath) as! PostCell
                  c.set(data)
                  cell = c
               case .ad(let data):
                  let c = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseId, for: indexPath) as! PostCell
                  c.set(data)
                  cell = c
               case .threads(let data):
                  let c = collectionView.dequeueReusableCell(withReuseIdentifier: ThreadsPostsCell.reuseID, for: indexPath) as! ThreadsPostsCell
                  c.set(data)
                  cell = c
               case .peopleSuggestion(let data):
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
      return .zero
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      guard indexPath.section == 0 else { return }
      
      let vc = StoriesPreviewVC(
         stories: viewModel.allStories,
         index: indexPath.row)
      self.navigationController?.pushViewController(vc, animated: true)
   }
}

// MARK: - Compositional Layout

extension FeedVC {
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
   
   private func createStoriesSection() -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(
         widthDimension: .absolute(80),
         heightDimension: .absolute(80)
      )
      
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(110))
      
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      group.interItemSpacing = .fixed(10)
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      section.contentInsets = .init(top: 10, leading: 15, bottom: 0, trailing: 0)
      
      return section
   }
   
   func createPostsSection() -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(
         widthDimension: .fractionalWidth(1.0),
         heightDimension: .estimated(260)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
      let groupSize = NSCollectionLayoutSize(
         widthDimension: .fractionalWidth(1.0),
         heightDimension: .estimated(260)
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
   func updateView() {
      DispatchQueue.main.async {
         self.collectionView.reloadData()
      }
   }
}

// MARK: Button Actions

extension FeedVC {
   @objc private func navBarDmButtonTapped() {}
   @objc private func navBarIgTvButtonTapped() {}
   @objc private func navBarCameraButtonTapped() {}
}
