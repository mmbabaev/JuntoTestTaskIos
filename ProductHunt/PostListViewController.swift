//
//  ViewController.swift
//  ProductHunt
//
//  Created by Mihail Babaev on 16.05.17.
//  Copyright © 2017 Mihail Babaev. All rights reserved.
//

import UIKit
import AlamofireImage

class PostListViewController: UITableViewController {
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostsService.shared.loadPosts() {
            posts in
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            } else {
                self.showErrorAlert(with: "Не удалось загрузить данные")
            }
        }
    }
    
    // MARK: Table view datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCellId") as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.descriptionLabel.text = post.description
        cell.titleLabel.text = post.title
        if let imageUrl = URL(string: post.thumbnailUrl) {
            cell.thubnailView.af_setImage(withURL: imageUrl)
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate 
    func
}

