//
//  AppDelegate.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2018/12/24.
//  Copyright © 2018 洪森達. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate,UNUserNotificationCenterDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = MainTabController()
        attemptRegisterNotification(App: application)
        return true
    }
    //Physical Phone's Token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("device token",deviceToken)
    }
    
    //Firebase Messaging Token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Fcm token form firebase",fcmToken)
    }
    
    //For foreground Notification Method
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.alert)
    }
    
    fileprivate func attemptRegisterNotification(App:UIApplication){
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        let options = UNAuthorizationOptions(arrayLiteral: .alert,.badge,.sound)
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            if granted {
                print("User granted..")
            }else {
                
                print("User denied")
            }
        }
        
        App.registerForRemoteNotifications()
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let userInfo = response.notification.request.content.userInfo as? [String:Any] else {return}
        guard let followerID = userInfo["followerId"] as? String else {return}
        
        if let mainTabarContoller = UIApplication.shared.keyWindow?.rootViewController as? MainTabController {
            mainTabarContoller.selectedIndex = 0
            mainTabarContoller.presentedViewController?.dismiss(animated: true, completion: nil)
            let userProfileContoller = UserProfileController(collectionViewLayout:UICollectionViewFlowLayout())
                userProfileContoller.userID = followerID
            if let nv = mainTabarContoller.viewControllers?.first as? UINavigationController {
                nv.pushViewController(userProfileContoller, animated: true)
            }
        }
    
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

