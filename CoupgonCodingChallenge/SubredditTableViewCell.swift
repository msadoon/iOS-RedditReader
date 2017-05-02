//
//  SubredditTableViewCell.swift
//  CoupgonCodingChallenge
//
//  Created by Mubarak Sadoon on 2017-04-28.
//  Copyright © 2017 Coupgon. All rights reserved.
//

import UIKit

class SubredditTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageViewLabel: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
