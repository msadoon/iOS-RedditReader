//
//  PostsTableViewController.swift
//  CoupgonCodingChallenge
//
//  Created by Mubarak Sadoon on 2017-04-30.
//  Copyright © 2017 Coupgon. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {

    var localPosts:[Post] = []
    var subreddit:Subreddit = Subreddit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 175
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        if let urlToUse:String = subreddit.url {
            self.navigationItem.title = urlToUse
            NetworkManager.sharedInstance.getPosts(subredditName: urlToUse) { (success) in
                if (success) {
                    self.postsFound()
                    self.tableView.reloadData()
                }
            }
        }

    }
    
    private func postsFound() {
        if let posts = UserSession.sharedInstance.user1.subredditPosts {
            localPosts = posts
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailTableViewControllerID") as! PostDetailTableViewController
        
        let foundPost:Post = localPosts[indexPath.row]
        
        vc.post = Post(title: foundPost.title, author: foundPost.author, creationDatetime:
            foundPost.creationDatetime, bodyText: foundPost.bodyText, thumbnailLinkURL: foundPost.thumbnailLinkURL, permalink: foundPost.permalink)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return localPosts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PostTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "PostTableViewCellID") as! PostTableViewCell
        
        cell.postTitle.text = localPosts[indexPath.row].title
        cell.postAuthor.text = localPosts[indexPath.row].author
        cell.postBodyText.text = localPosts[indexPath.row].bodyText
        cell.postCreationDateTime.text = localPosts[indexPath.row].creationDatetime
        let placeholderImage = UIImage(named: "placeholder")
        guard let previewURL = localPosts[indexPath.row].thumbnailLinkURL else {
            cell.postImageView.image = placeholderImage
            return cell;
        }
        
        let url = URL(string: previewURL)
        cell.postImageView.sd_setImage(with: url, placeholderImage:placeholderImage)
        
        return cell;
        
    }

}
