//
//  UIViewControllerExtension.swift
//  ProductHunt
//
//  Created by Mihail Babaev on 17.05.17.
//  Copyright © 2017 Mihail Babaev. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlert(with error: String) {
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}
