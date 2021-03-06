//
//  AppDelegate.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 2/19/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import Firebase
//not sure why this is giving an error

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let colorCoral = UIColor(red: 249/255.0, green: 113/255.0, blue: 113/255.0, alpha: 1.0)
        let blueGrayColor = UIColor(red: 204/255.0, green: 218, blue: 233/255.0, alpha: 1.0)
        let darkBlue = UIColor(red: 0/255.0, green: 0/255.0, blue: 51/255.0, alpha: 1.0)
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().tintColor = darkBlue
        
//        let authListener = Auth.auth().addStateDidChangeListener({auth, user in
//            
//            if user != nil{
//                UserService.observeUserProfile(_uid: user!.uid) { userProfile in
//                    UserService.currentUserProfile = userProfile
//                }
//        
//            }
//            
//            else{
//                UserService.currentUserProfile = nil
//            }
//            
//            
//        })
        
        
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

