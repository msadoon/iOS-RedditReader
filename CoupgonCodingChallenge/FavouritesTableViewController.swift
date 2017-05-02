//
//  FavouritesTableViewController.swift
//  CoupgonCodingChallenge
//
//  Created by Mubarak Sadoon on 2017-05-02.
//  Copyright © 2017 Coupgon. All rights reserved.
//

import UIKit

protocol FavouritesDelegate:class {
    func addToFavourites()
    func removeFromFavourites()
}

class FavouritesTableViewController: UITableViewController {
    @IBOutlet weak var dismissButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserSession.sharedInstance.favouritePosts.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailTableViewControllerID") as! PostDetailTableViewController
        let foundPost:Post = UserSession.sharedInstance.favouritePosts[indexPath.row]
        
        vc.post = Post(title: foundPost.title, author: foundPost.author, creationDatetime:
            foundPost.creationDatetime, bodyText: foundPost.bodyText, thumbnailLinkURL: foundPost.thumbnailLinkURL, permalink: foundPost.permalink)

        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PostTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "PostTableViewCellID") as! PostTableViewCell
        
        cell.postTitle.text = UserSession.sharedInstance.favouritePosts[indexPath.row].title
        cell.postAuthor.text = UserSession.sharedInstance.favouritePosts[indexPath.row].author
        cell.postBodyText.text = UserSession.sharedInstance.favouritePosts[indexPath.row].bodyText
        cell.postCreationDateTime.text = UserSession.sharedInstance.favouritePosts[indexPath.row].creationDatetime
        let placeholderImage = UIImage(named: "placeholder")
        guard let previewURL = UserSession.sharedInstance.favouritePosts[indexPath.row].thumbnailLinkURL else {
            cell.postImageView.image = placeholderImage
            return cell;
        }
        
        let url = URL(string: previewURL)
        cell.postImageView.sd_setImage(with: url, placeholderImage:placeholderImage)
        
        return cell;
    }
    @IBAction func dismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            //nothing
            
        })
    }

}


