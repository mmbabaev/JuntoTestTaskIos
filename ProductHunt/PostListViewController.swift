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
    
    var posts: [Post] {
        return PostsService.shared.currentPosts
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.separatorStyle = .singleLine
        
        self.addBackgroundLabel()
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        self.reload()
    }
    
    func addBackgroundLabel() {
        let bounds = self.view.bounds
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let label = UILabel(frame: frame)
        label.text = "В данной категории нет постов за сегодня"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        
        self.tableView.backgroundView = label
    }
    
    func reload() {
        PostsService.shared.loadPosts(with: updatePosts)
    }
    
    func updatePosts(success: Bool) {
        self.tableView.refreshControl?.endRefreshing()
        if success {
            self.tableView.reloadData()
        } else {
            self.showErrorAlert(with: "Не удалось загрузить данные")
        }
    }
    
    // MARK: Table view datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCellId") as! PostTableViewCell
        let post = posts[indexPath.row]
        
        cell.configure(with: post)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // MARK: UITableViewDelegate 
    
}

