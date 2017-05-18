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
    
    var selectedCategory: Category!
    var currentPosts = [Post]()
    
    private let categoriesKey = "UDCategories"
    var categories = [Category]()
    
    private init() {}
    private let baseUrl = "https://api.producthunt.com/v1/"
    private let tokenParamDict = ["access_token" : "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"]
    
    func selectCategory(at index: Int) {
        selectedCategory = categories[index]
        currentPosts = []
    }
    
    func updateCategories(with callback: @escaping (Bool) -> Void) {
        let url = "\(baseUrl)categories"
        Alamofire.request(url,
            method: .get,
            parameters: tokenParamDict).responseJSON { response in
                guard let data = response.data, response.result.isSuccess else {
                    callback(false)
                    return
                }
                
                let json = JSON(data: data)
                self.categories = json["categories"].arrayValue.map({ jsonCategory in
                    return Category(name: jsonCategory["name"].stringValue,
                                    slug: jsonCategory["slug"].stringValue,
                                    colorCode: jsonCategory["color"].stringValue)
                })
                if !self.categories.isEmpty {
                    self.selectedCategory = self.categories[0]
                }
                
                callback(true)
        }
    }
    
    func loadPosts(with callback:@escaping (Bool) -> Void) {
        let url = "\(baseUrl)categories/\(selectedCategory.slug)/posts"
        
        Alamofire.request(url,
            method: .get,
            parameters: tokenParamDict).responseJSON { response in
                guard let data = response.data, response.result.isSuccess else {
                    callback(false)
                    return
                }
            
                let json = JSON(data: data)
                let posts = json["posts"].arrayValue.map({ Post(json: $0) })
                self.currentPosts = posts
                callback(true)
        }
    }
}
