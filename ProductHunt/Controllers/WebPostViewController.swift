//
//  WebPostViewController.swift
//  ProductHunt
//
//  Created by Mihail Babaev on 18.05.17.
//  Copyright © 2017 Mihail Babaev. All rights reserved.
//

import UIKit

class WebPostViewController: UIViewController {
    var urlString: String! 
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let url = URL(string: urlString) {
            webView.loadRequest(URLRequest(url: url))
        }
    }
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
