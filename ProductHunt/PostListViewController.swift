//
//  ViewController.swift
//  ProductHunt
//
//  Created by Mihail Babaev on 16.05.17.
//  Copyright © 2017 Mihail Babaev. All rights reserved.
//

import UIKit
import AlamofireImage
import BTNavigationDropdownMenu
import MBProgressHUD

class PostListViewController: UITableViewController {
    
    var posts: [Post] {
        return PostsService.shared.currentPosts
    }
    var categories: [String] {
        return PostsService.shared.categories.map({ $0.name })
    }
    var menu: BTNavigationDropdownMenu!
    weak var selectedMenuLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
        
        self.tableView.separatorStyle = .none
        
        self.addBackgroundLabel()
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        
        loadCategories()
    }
    
    func loadCategories() {
        let tryAgainAction: ((UIAlertAction) -> Void) = { action in self.loadCategories() }

        MBProgressHUD.showAdded(to: self.view, animated: true)
        PostsService.shared.updateCategories() { success in
            MBProgressHUD.hide(for: self.view, animated: true)
            if !success || self.categories.isEmpty {
                self.showErrorAlert(with: "An error occurred, please try again.", okHandler: tryAgainAction)
            } else {
                self.loadPosts()
            }
        }
    }
    
    func addBackgroundLabel() {
        let bounds = self.view.bounds
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 4)
        let label = UILabel(frame: frame)
        label.text = "No any posts today in selected category."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        
        self.tableView.backgroundView = label
    }
    
    func loadPosts() {
        PostsService.shared.loadPosts(with: updatePosts)
    }
    
    func updatePosts(success: Bool) {
        self.tableView.refreshControl?.endRefreshing()
        if success {
            self.reload()
        } else {
            self.showErrorAlert(with: "An error occurred, please try again.")
        }
    }
    
    func reload() {
        self.reloadDropdownCategories()
        self.tableView.reloadData()
        self.tableView.separatorStyle = posts.count == 0 ? .none : .singleLine
    }
    
    func reloadDropdownCategories() {
        let category = PostsService.shared.selectedCategory.name
        self.menu = BTNavigationDropdownMenu(title: category, items: self.categories as [AnyObject])
        self.navigationItem.titleView = menu
        
        menu.didSelectItemAtIndexHandler = { index in
            PostsService.shared.selectCategory(at: index)
            self.reload()
            self.loadPosts()
            self.reloadDropdownCategories()
        }
    }
    
    // MARK: - UITableViewDatasource
    
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPost" {
            let postVC = segue.destination as! PostViewController
            let index = self.tableView.indexPathForSelectedRow!.row
            postVC.post = posts[index]
        }
    }
}

