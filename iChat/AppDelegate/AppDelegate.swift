//
//  AppDelegate.swift
//  iChat
//
//  Created by Mavin Sao on 14/9/21.
//

import UIKit
import Firebase
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        IQKeyboardManager.shared().isEnabled = false
        
//        do {
//            // Create JSON Encoder
//            let decoder = JSONDecoder()
//            if let userData = UserDefaults.standard.data(forKey: "user"){
//               let user = try decoder.decode(User.self, from: userData)
//                if let uid = UserDefaults.standard.string(forKey: "currentID"){
//                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                    if user.id == uid {
//                       
//                        let mainTab = storyBoard.instantiateViewController(identifier: "MainTabBar") as! MainTabViewController
//                        UIApplication.shared.windows.first?.rootViewController = mainTab
//                    }else{
//                        let LoginVC = storyBoard.instantiateViewController(identifier: "LoginVC") as! LoginViewController
//                        UIApplication.shared.windows.first?.rootViewController = LoginVC
//                        
//                    }
//                }
//            }
//        } catch {
//            print("Unable to Encode Note (\(error))")
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

