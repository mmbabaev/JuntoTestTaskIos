//
//  AppDelegate.swift
//  ProductHunt
//
//  Created by Mihail Babaev on 16.05.17.
//  Copyright © 2017 Mihail Babaev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(30)
        NotificationService.shared.requestGrant()
               
        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationService.shared.stopObserving()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationService.shared.startObserving()
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NotificationService.shared.fetchForNotifications(completion: completionHandler)
        completionHandler(.noData)
    }
}

