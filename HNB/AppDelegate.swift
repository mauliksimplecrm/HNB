//
//  AppDelegate.swift
//  SalesMobiX
//
//  Created by Apple on 12/04/22.
//

import UIKit
import FirebaseCore
//import FirebaseMessaging
import FirebaseMessaging
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        
        //-------Firebase Push Notification---------
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        //------------------------------------------
        
        //Sleep for 1s to show splash screen for longer
        Thread.sleep(forTimeInterval: 1.0)
        
        
        IQKeyboardManager.shared.enable = true
        
        //--
        UserDefaults.standard.setValue("https://hnbupgradeuatcp.simplecrmdev.com/Api/V8/update_user_details", forKey: "update_user_details")
        UserDefaults.standard.synchronize()
        
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
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    //
    //    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    //       print("Firebase registration token: \(String(describing: fcmToken))")
    //
    //       let dataDict: [String: String] = ["token": fcmToken ?? ""]
    //       NotificationCenter.default.post(
    //         name: Notification.Name("FCMToken"),
    //         object: nil,
    //         userInfo: dataDict
    //       )
    //       // TODO: If necessary send token to application server.
    //       // Note: This callback is fired at each app startup and whenever a new token is generated.
    //     }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        UserDefaults.standard.set(fcmToken, forKey: "FirebaseToken")
        UserDefaults.standard.synchronize()
        
    }
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    //Device Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device Token : ",token)
        //Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("=====================")
        let userInfo = response.notification.request.content.userInfo
        if let dicData = userInfo["data"] as? NSDictionary{
            if let url = dicData["url"] as? String{
                UserDefaults.standard.set(url, forKey: "Notification_URL")
                UserDefaults.standard.synchronize()
            }
        }
        if let url = userInfo["url"] as? String{
            UserDefaults.standard.set(url, forKey: "Notification_URL")
            UserDefaults.standard.synchronize()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            NotificationCenter.default.post(name: Notification.Name("ReceivePushNotification"), object: nil, userInfo: userInfo)
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        
        completionHandler([.banner, .list])
    }
    /*
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        // Update the app interface directly.
        print("-----------")
        
        if UIApplication.shared.applicationState == .active
        {
            print("active")
        }
        else
        {
            print("other")
            
            let userInfo = notification.request.content.userInfo
            if let dicData = userInfo["data"] as? NSDictionary{
                if let url = dicData["url"] as? String{
                    UserDefaults.standard.set(url, forKey: "Notification_URL")
                    UserDefaults.standard.synchronize()
                }
            }
            if let url = userInfo["url"] as? String{
                UserDefaults.standard.set(url, forKey: "Notification_URL")
                UserDefaults.standard.synchronize()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                NotificationCenter.default.post(name: Notification.Name("ReceivePushNotification"), object: nil, userInfo: userInfo)
            }
        }
        
        // Show a banner
        completionHandler(.banner)
        
    }
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            print("Notification Data: ",userInfo)
    
            
            if let dicData = userInfo["data"] as? NSDictionary{
                if let url = dicData["url"] as? String{
                    UserDefaults.standard.set(url, forKey: "Notification_URL")
                    UserDefaults.standard.synchronize()
                }
            }
            if let url = userInfo["url"] as? String{
                UserDefaults.standard.set(url, forKey: "Notification_URL")
                UserDefaults.standard.synchronize()
            }
            
            NotificationCenter.default.post(name: Notification.Name("ReceivePushNotification"), object: nil, userInfo: userInfo)
            
            completionHandler(.newData)
    
        }*/
    
    //    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    //        print(response.notification.request.content.userInfo)
    //        let userInfo = response.notification.request.content.userInfo
    //        if let dicData = userInfo["data"] as? NSDictionary{
    //            if let url = dicData["url"] as? String{
    //                UserDefaults.standard.set(url, forKey: "Notification_URL")
    //                UserDefaults.standard.synchronize()
    //            }
    //        }
    //        if let url = userInfo["url"] as? String{
    //            UserDefaults.standard.set(url, forKey: "Notification_URL")
    //            UserDefaults.standard.synchronize()
    //        }
    //
    //        NotificationCenter.default.post(name: Notification.Name("ReceivePushNotification"), object: nil, userInfo: userInfo)
    //
    //        completionHandler()
    //
    //    }
    
    
    /*
     - (void)userNotificationCenter:(UNUserNotificationCenter *)center
     willPresentNotification:(UNNotification *)notification
     withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
     // The method will be called on the delegate only if the application is in the foreground.
     // If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented.
     // The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list.
     // This decision should be based on whether the information in the notification is otherwise visible to the user.
     
     }
     - (void)userNotificationCenter:(UNUserNotificationCenter *)center
     didReceiveNotificationResponse:(UNNotificationResponse *)response
     withCompletionHandler:(void(^)())completionHandler {
     // The method will be called on the delegate when the user responded to the notification by opening the application,
     // dismissing the notification or choosing a UNNotificationAction.
     // The delegate must be set before the application returns from applicationDidFinishLaunching:.
     
     }
     */
}
