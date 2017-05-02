//
//  PostDetailTableViewCell.swift
//  CoupgonCodingChallenge
//
//  Created by Mubarak Sadoon on 2017-05-01.
//  Copyright © 2017 Coupgon. All rights reserved.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var bodyText: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var like_button:UIButton!
    weak var delegate:FavouritesDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        like_button.setImage(UIImage(named:"unliked"), for: UIControlState.normal)
        like_button.setImage(UIImage(named:"liked"), for: UIControlState.selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func favPressed(_ sender: UIButton) {
        like_button.isSelected = !like_button.isSelected
        if like_button.isSelected {

            self.delegate?.addToFavourites()
        } else {

            self.delegate?.removeFromFavourites()
        }
    }
}
