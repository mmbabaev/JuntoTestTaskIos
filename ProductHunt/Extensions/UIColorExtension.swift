//
//  UIColorExtension.swift
//  ProductHunt
//
//  Created by Mihail Babaev on 18.05.17.
//  Copyright © 2017 Mihail Babaev. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let input = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: input)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
