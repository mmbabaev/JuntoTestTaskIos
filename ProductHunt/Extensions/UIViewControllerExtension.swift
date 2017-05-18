//
//  UIViewControllerExtension.swift
//  ProductHunt
//
//  Created by Mihail Babaev on 17.05.17.
//  Copyright © 2017 Mihail Babaev. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlert(with error: String, okHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: okHandler)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
