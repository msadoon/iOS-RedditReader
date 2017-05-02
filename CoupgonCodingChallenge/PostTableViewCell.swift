//
//  PostTableViewCell.swift
//  CoupgonCodingChallenge
//
//  Created by Mubarak Sadoon on 2017-04-28.
//  Copyright © 2017 Coupgon. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postBodyText: UILabel!
    @IBOutlet weak var postCreationDateTime: UILabel!
    @IBOutlet weak var postAuthor: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
