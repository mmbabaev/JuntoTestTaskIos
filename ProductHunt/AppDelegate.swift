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
        
        NotificationService.shared.requestGrant()
               
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationService.shared.startObserving()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationService.shared.stopObserving()
    }
}

