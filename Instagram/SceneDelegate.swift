//
//  SceneDelegate.swift
//  Instagram
//
//  Created by Alpay Calalli on 28.10.25.
//

import UIKit

// TODO: Liked by userin imagei yoxdu
// TODO: Representablelari temizlemek
// TODO: PostDateLabel fix
// TODO: 5h (timeLabel) in threads fix
// TODO: ThreadsPost : vertical padding
// TODO: ThreadsPost : image size and alignment
// TODO: NormalPostCell.post image : current page indicator label on top right
// TODO: Stack viewlari lazy var-a kecirtmek belke
// TODO: Configure -> layoutUI
// TODO: Accessibility - dynamic type
// TODO: ThreadSeeMoreCell eslinde problemlidi layout setupdi
// TODO: Hide page indictors on ad post

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

   var window: UIWindow?


   func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      guard let windowScene = (scene as? UIWindowScene) else { return }

      let myViewController = FeedVC()
      let navigationController = UINavigationController(rootViewController: myViewController)

      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = navigationController
      self.window = window
      window.makeKeyAndVisible()
   }

   func sceneDidDisconnect(_ scene: UIScene) {
      // Called as the scene is being released by the system.
      // This occurs shortly after the scene enters the background, or when its session is discarded.
      // Release any resources associated with this scene that can be re-created the next time the scene connects.
      // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
   }

   func sceneDidBecomeActive(_ scene: UIScene) {
      // Called when the scene has moved from an inactive state to an active state.
      // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
   }

   func sceneWillResignActive(_ scene: UIScene) {
      // Called when the scene will move from an active state to an inactive state.
      // This may occur due to temporary interruptions (ex. an incoming phone call).
   }

   func sceneWillEnterForeground(_ scene: UIScene) {
      // Called as the scene transitions from the background to the foreground.
      // Use this method to undo the changes made on entering the background.
   }

   func sceneDidEnterBackground(_ scene: UIScene) {
      // Called as the scene transitions from the foreground to the background.
      // Use this method to save data, release shared resources, and store enough scene-specific state information
      // to restore the scene back to its current state.
   }


}

