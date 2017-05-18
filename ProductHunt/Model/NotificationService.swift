//
//  Notificator.swift
//  ProductHunt
//
//  Created by Mihail Babaev on 18.05.17.
//  Copyright © 2017 Mihail Babaev. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class NotificationService {
    
    static let shared = NotificationService()
    
    private init() {}
    
    private var isGranted: Bool = false
    private var timer: Timer!
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    private var oldPostIds = [Int]()
    private var provider: PostsProvider {
        return PostsProvider.shared
    }
    
    func requestGrant() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge];
        center.requestAuthorization(options: options) {
            (granted, error) in
            self.isGranted = granted
        }
    }
    
    func startObserving() {
        if !isGranted {
            return
        }
        
        oldPostIds = provider.currentPosts.map({ $0.id })
    }
    
    func stopObserving() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func fetchForNotifications(completion: @escaping (UIBackgroundFetchResult) -> Void) {
        print(Date())
        print(provider.currentPosts.count)

        PostsProvider.shared.loadPosts() { success in
            if !success {
                return
            }
            
            let newPosts = self.provider.currentPosts.filter({
                !self.oldPostIds.contains($0.id)
            })
            
            if newPosts.count == 1 {
                self.sendNotification(with: newPosts.first!)
            }
            
            if newPosts.count > 1 {
                self.sendNotification(with: newPosts.count)
            }
            
            if newPosts.count > 0 {
                completion(.newData)
            } else {
                completion(.noData)
            }
        }
    }

    private func sendNotification(with post: Post) {
        //Set the content of the notification
        let content = UNMutableNotificationContent()
        content.title = "New post \(post.title)!"
        content.body = "\(post.description) "
        
        self.sendNotification(with: content)
    }
    
    private func sendNotification(with newPostsCount: Int) {
        //Set the content of the notification
        let content = UNMutableNotificationContent()
        content.title = "New posts!"
        content.body = "Check \(newPostsCount) new posts"
        
        sendNotification(with: content)
    }
    
    private func sendNotification(with content: UNMutableNotificationContent) {
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "alarm"
        
        //Set the trigger of the notification -- here a timer.
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 2.0,
            repeats: false)
        
        //Set the request for the notification from the above
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
    }
}
