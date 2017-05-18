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
        return PostsProvider.shared.currentPosts
    }
    var categories: [String] {
        return PostsProvider.shared.categories.map({ $0.name })
    }
    var menu: BTNavigationDropdownMenu!
    var backgroundLabel: UILabel?
    
    // MARK: - Setup controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationItem()
        self.setupTableView()
        
        loadCategories()
    }
    
    func setupTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 40.0
        
        self.tableView.separatorStyle = .none
        
        self.addBackgroundLabel()
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func setupNavigationItem() {
        self.navigationItem.title = "Tech"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.menu = BTNavigationDropdownMenu(title: "Tech", items: self.categories as [AnyObject])
        
        menu.shouldKeepSelectedCellColor = true
        menu.cellTextLabelColor = UIColor.white
        menu.cellTextLabelAlignment = .center
        menu.maskBackgroundColor = UIColor.black
        self.navigationItem.titleView = menu
    }
    
    func addBackgroundLabel() {
        let bounds = self.view.bounds
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 4)
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.isHidden = true
        self.backgroundLabel = label
        
        self.tableView.backgroundView = label
    }
    
    // MARK: - Load operations
    
    func loadCategories() {
        let tryAgainAction: ((UIAlertAction) -> Void) = { action in self.loadCategories() }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        PostsProvider.shared.updateCategories() { success in
            MBProgressHUD.hide(for: self.view, animated: true)
            if !success || self.categories.isEmpty {
                self.showErrorAlert(with: "An error occurred, please try again.", okHandler: tryAgainAction)
            } else {
                self.loadPosts()
            }
        }
    }
    
    func loadPosts() {
        self.backgroundLabel?.text = "Loading posts..."
        PostsProvider.shared.loadPosts(with: updatePosts)
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
        
        if posts.count == 0 {
            self.tableView.separatorStyle = .none
            self.tableView.backgroundView?.isHidden = false
        } else {
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundView?.isHidden = true
        }
        self.backgroundLabel?.text = "No any posts today in selected category."
    }
    
    func reloadDropdownCategories() {
        let category = PostsProvider.shared.selectedCategory!
        self.menu.updateItems(self.categories as [AnyObject])
        
        let color = UIColor(hex: category.colorCode)
        menu.cellBackgroundColor = color
        
        self.navigationItem.title = category.name
        self.navigationController?.navigationBar.barTintColor = color
        
        menu.didSelectItemAtIndexHandler = { index in
            PostsProvider.shared.selectCategory(at: index)
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

