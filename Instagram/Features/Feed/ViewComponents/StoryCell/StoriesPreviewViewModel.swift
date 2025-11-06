//
//  StoriesPreviewViewModel.swift
//  Instagram
//
//  Created by Alpay Calalli on 05.11.25.
//

import UIKit

class StoriesPreviewViewModel {
   private var currentStoryIndex: Int
   private var stories: [StoryDataModel]
   
   /// To control story duration
   var timer: Timer?
   
   var currentStory: StoryModel? {
      stories[currentStoryIndex].storyModel
   }
   
   weak var output: StoriesPreviewViewModelOutput?
   
   init(stories: [StoryDataModel], currentStoryIndex: Int) {
      self.stories = stories
      self.currentStoryIndex = currentStoryIndex
   }
   
   func configureStoryTimer() {
      timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
         // 5 seconds total / 0.05 interval = 100 ticks → each tick should add 1/100 = 0.01
         self.output?.timerUpdated()
      }
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
   
   @objc func leftSideOfScreenLongPressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
      switch gestureRecognizer.state {
         case .began: timer?.invalidate()
         case .ended: configureStoryTimer()
         default: break;
      }
   }
   
   @objc func rightSideOfScreenTapped() {
      handleForwardAction()
   }
}
