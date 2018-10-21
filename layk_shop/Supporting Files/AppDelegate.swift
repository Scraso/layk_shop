//
//  AppDelegate.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/17/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, DataCountListenerDelegate {
    
    var window: UIWindow?
    var tokens = [FCMToken]()
    
    // Count listener functions to update History Bar badge count and app icon
    func historyBadgeCount(count: Int) {
        let myTabBar = self.window?.rootViewController as! UITabBarController
        if let tabItems = myTabBar.tabBar.items {
            let tabItem = tabItems[2]
            if count == 0 || count < 0 {
                tabItem.badgeValue = nil
            } else {
                tabItem.badgeValue = String(count)
            }
        }
    }
    
    func appBadgeCount(count: Int) {
        if count < 0 {
            UIApplication.shared.applicationIconBadgeNumber = 0
        } else {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        // Enabled Fabric SDK
        Fabric.sharedSDK().debug = true
        
        let settings = DB_BASE.settings
        settings.areTimestampsInSnapshotsEnabled = true
        DB_BASE.settings = settings
        
        // Enable Keyboard Manager
        IQKeyboardManager.shared.enable = true
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // Call singleton and confirm to delegate to listen for badge count changes
        let dataCountService = DataCountListenerService.instance
        dataCountService.delegate = self
        dataCountService.fetchAppIconCount()
        dataCountService.fetchHistoryBadgeCount()
        
        return true
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
        ReachabilityManager.shared.stopMonitoring()
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        ReachabilityManager.shared.startMonitoring()
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Open HistoryViewController when PushNotification pressed
        let myTabBar = self.window?.rootViewController as! UITabBarController
        myTabBar.selectedIndex = 2
    
        print("Notification opened")
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict: [String: Any] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        DataService.instance.REF_FCM_TOKEN_ALL.getDocuments {(documentSnapshot, error) in
            
            if let error = error {
                print("Error fetching snapshots: \(error)")
            } else {
                // Fetch all tokens and add to the array
                if let documents = documentSnapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        let tokens = FCMToken(data: data)
                        self.tokens.append(tokens)
                    }
                    // Check if array contains current user token
                    if self.tokens.contains(where: {$0.token == fcmToken}) {
                        print("Already exist")
                    } else {
                        DataService.instance.REF_FCM_TOKEN_ALL.document().setData(dataDict)
                    }
                    
                }
            }
        }
        
        // Check if user total badge count document is exist and if not then create and set badge to 0
        let badgeCountTotalRef = DataService.instance.REF_BADGE_COUNT_TOTAL.document(fcmToken)
        badgeCountTotalRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                DataService.instance.REF_BADGE_COUNT_TOTAL.document(fcmToken).setData(["count": 0])
            }
        }
        
        // Check if detailed News badge count document is exist and if not then create and set badge to 0
        let badgeNewsCountRef = DataService.instance.REF_BADGE_COUNT_DETAILS.document("news_badges_count").collection("fcmTokens").document(fcmToken)
        badgeNewsCountRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                DataService.instance.REF_BADGE_COUNT_DETAILS.document("news_badges_count").collection("fcmTokens").document(fcmToken).setData(["count": 0])
            }
        }
        
        // Check if detailed History badge count document is exist and if not then create and set badge to 0
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        let badgeHistoryCountRef = DataService.instance.REF_BADGE_COUNT_DETAILS.document("history_badges_count").collection("badgeCount").document(currentUserUid)
        badgeHistoryCountRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                DataService.instance.REF_BADGE_COUNT_DETAILS.document("history_badges_count").collection("badgeCount").document(currentUserUid).setData(["count": 0])
            }
        }
        
    }
    
}

