//
//  Post.swift
//  ProductHunt
//
//  Created by Mihail Babaev on 16.05.17.
//  Copyright © 2017 Mihail Babaev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Post {
    let title: String
    let description: String
    let votesCount: Int
    let thumbnailUrl: String
    
    let imageUrl: String
    
    let redirectUrl: String
    
    init(json: JSON) {
        title = json["name"].stringValue
        thumbnailUrl = json["thumbnail"]["image_url"].stringValue
        redirectUrl = json["redirect_url"].stringValue
        votesCount = json["votes_count"].intValue
        imageUrl = json["image_url"]["original"].stringValue
        description = json["tagline"].stringValue
    }
}