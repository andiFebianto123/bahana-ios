//
//  SceneDelegate.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/29.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // If language not setted yet, set default language to Bahasa
        if getLocalData(key: "language") == "" {
            let locale = Bundle.main.preferredLocalizations.first!
            if locale == "id" {
                setLocalData(["language": "language_id"])
            } else {
                setLocalData(["language": "language_en"])
            }
        }
        
        // Check if app update available
        isAppUpdateAvailable() { isAvailable in
            if isAvailable {
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let appUpdateViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "AppUpdate") as UIViewController
                self.window?.rootViewController = appUpdateViewController
            } else if !isLoggedIn() {
                // Check if user already logged in
                let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
                let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
                self.window?.rootViewController = loginViewController
            }
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

