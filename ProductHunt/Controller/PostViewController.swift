//
//  PostViewController.swift
//  ProductHunt
//
//  Created by Mihail Babaev on 17.05.17.
//  Copyright © 2017 Mihail Babaev. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white

        titleLabel.text = post.title
        votesLabel.text = String("\(post.votesCount)")
        descriptionTextView.text = post.description
        
        descriptionTextView.allowsEditingTextAttributes = false
        
        if let imageUrl = URL(string: post.screenshotUrl) {
            print(imageUrl)
            imageView.af_setImage(withURL: imageUrl)
        }
    }
}
