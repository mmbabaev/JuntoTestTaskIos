//
//  PostTableViewCell.swift
//  ProductHunt
//
//  Created by Mihail Babaev on 17.05.17.
//  Copyright © 2017 Mihail Babaev. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thubnailView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thubnailView.image = nil
    }
}
