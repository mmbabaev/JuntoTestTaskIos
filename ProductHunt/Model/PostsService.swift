//
//  PostsService.swift
//  ProductHunt
//
//  Created by Mihail Babaev on 16.05.17.
//  Copyright © 2017 Mihail Babaev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PostsService {
    static let shared = PostsService()
    
    let baseUrl = "https://api.producthunt.com/v1/"
    let accessToken = "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"
    
    let selectedCategory: String! = "tech"
    var currentPosts = [Post]()
    
    private init() {}
    
    func updateCategories(with callback: ([String]?) -> Void) {
        
    }
    
    func loadPosts(with callback:@escaping ([Post]?) -> Void) {
        Alamofire.request("\(baseUrl)categories/\(selectedCategory)/posts",
            method: .get,
            parameters: ["access_token" : accessToken]).responseJSON { response in
                guard let data = response.data else {
                    callback(nil)
                    return
                }
                
                if response.result.isFailure {
                    callback(nil)
                    return
                }
                
                let json = JSON(data: data)
                let posts = json["posts"].arrayValue.map({ Post(json: $0) })
                self.currentPosts = posts
                callback(posts)
        }
    }
}
