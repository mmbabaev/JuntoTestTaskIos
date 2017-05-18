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
    let id: Int
    let title: String
    let description: String
    let votesCount: Int
    
    let thumbnailUrl: String
    let screenshotUrl: String
    
    let redirectUrl: String
    
    init(json: JSON) {
        id = json["id"].intValue
        title = json["name"].stringValue
        thumbnailUrl = json["thumbnail"]["image_url"].stringValue
        redirectUrl = json["redirect_url"].stringValue
        votesCount = json["votes_count"].intValue
        screenshotUrl = json["screenshot_url"]["850px"].stringValue
        description = json["tagline"].stringValue
    }
}
