//
//  AppDelegate.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/29.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Add Firebase
        FirebaseApp.configure()
        
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

