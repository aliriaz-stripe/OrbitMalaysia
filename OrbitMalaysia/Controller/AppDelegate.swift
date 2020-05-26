//
//  AppDelegate.swift
//  OrbitMalaysia
//
//  Created by Martin Parker on 16/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import IQKeyboardManagerSwift
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let testPublishKey = "pk_test_mKM8fraL5eCUMWxQnd3NwFfb00nbQ5EsDN"
       // let livePublishKey = "pk_live_9eYbeVcjHIN5p88bNWJ1uYFO00lqvPvcQg"
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        Stripe.setDefaultPublishableKey(testPublishKey)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
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
    //For google sign in
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//
//        let stripeHandled = Stripe.handleURLCallback(with: url)
//
//        if stripeHandled {
//            return true
//        } else{
//           (GIDSignIn.sharedInstance()?.handle(url))!
//        }
//        return false
//    }
    // This method handles opening native URLs (e.g., "yourexampleapp://")

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        print("got url callback " + url.absoluteString)

        let stripeHandled = Stripe.handleURLCallback(with: url)

        let googleSignIn =  (GIDSignIn.sharedInstance()?.handle(url))!
        
        if (stripeHandled) {

            print("stripe handled it")

            return true

        } else if (googleSignIn){
             
            print("Google handles it")
            
            return true
            

        }

        return false

    }
    
    
}

