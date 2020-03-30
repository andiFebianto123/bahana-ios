//
//  AppDelegate.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/29.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit
import LanguageManager_iOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Check if user already logged in
        if !isLoggedIn() {
            let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
            self.window?.rootViewController = loginViewController
        }
        
        // If language not setted yet, set default language to Bahasa
        if getLocalData(key: "language") == "" {
            setLocalData(["language": "language_id"])
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

