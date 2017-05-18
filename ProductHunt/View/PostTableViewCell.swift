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
    @IBOutlet weak var votesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thubnailView.image = UIImage(named: "productHunt")
    }
    
    func configure(with post: Post) {
        descriptionLabel.text = post.description
        titleLabel.text = post.title
        if let imageUrl = URL(string: post.thumbnailUrl) {
            self.thubnailView.af_setImage(withURL: imageUrl)
        }
        votesLabel.text = String(post.votesCount)
    }

}
