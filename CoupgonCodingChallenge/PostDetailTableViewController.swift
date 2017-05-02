//
//  PostDetailTableViewController.swift
//  CoupgonCodingChallenge
//
//  Created by Mubarak Sadoon on 2017-04-30.
//  Copyright © 2017 Coupgon. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {

    var post:Post?
    var numberOfCommentCellsToDequeue:Int = 0;
    var allComments:[Comment] = []
    var dictionaryMap:[Int:(Comment,Int)] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        guard let linkToCommentsExists:String = post?.permalink else {
            return
        }
        
        NetworkManager.sharedInstance.getComments(commentLink: linkToCommentsExists) { (success, commentsWithReplies) in
            if (success) {
                self.allComments = commentsWithReplies
                self.countComments(array: commentsWithReplies)
                self.mapIndexPathRowsToDepthOfComment()
                self.tableView.reloadData()
            } else {
                self.numberOfCommentCellsToDequeue = 0;
                self.tableView.reloadData()
            }
        }

    }
    
    private func mapIndexPathRowsToDepthOfComment() {
        if allComments.count > 0 {
            var depthCounter = 0
            var tempComment = allComments[0]
            var topLevelCounter = 0
            for index in 0..<numberOfCommentCellsToDequeue {
                
                dictionaryMap[index] = (tempComment,depthCounter)
                
                if doesThisCommentHaveAReply(commentToCheck: tempComment) {
                    depthCounter += 1
                    tempComment = tempComment.reply!
                } else {
                    depthCounter = 0;
                    topLevelCounter += 1;
                    if topLevelCounter == allComments.count {
                        break;
                    }
                    tempComment = allComments[topLevelCounter]
                    
                }
            }
        }
    }
    
    private func countComments(array:[Comment]) {
        for comment in array {
            
            numberOfCommentCellsToDequeue += 1
            countReplies(comment: comment)
        }
    }
    
    
    private func countReplies(comment:Comment) {
        
        if doesThisCommentHaveAReply(commentToCheck: comment) {
                numberOfCommentCellsToDequeue += 1
            if let reply:Comment = comment.reply {
                countReplies(comment: reply)
            }
        }
    }
    private func doesThisCommentHaveAReply(commentToCheck:Comment) -> Bool {
        if let _:Comment = commentToCheck.reply {
            return true
        } else {
            return false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return numberOfCommentCellsToDequeue
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell:PostDetailTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCellID") as! PostDetailTableViewCell
                cell.delegate = self;
                cell.author.text = post?.author
                cell.title.text = post?.title
                cell.bodyText.text = post?.bodyText
                let placeholderImage = UIImage(named: "placeholder")
                guard let previewURL = post?.thumbnailLinkURL else {
                    cell.postImageView.image = placeholderImage
                    return cell;
                }
                
                let url = URL(string: previewURL)
                cell.postImageView.sd_setImage(with: url, placeholderImage:placeholderImage)
                
                if let postToUse:Post = post {
                    if self.isPostInFavourites(postToAdd: postToUse).0 {
                        cell.like_button.isSelected = true;
                    }
                }
                
                return cell;
            }
        } else {
            
                let cell:CommentTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCellID") as! CommentTableViewCell
            
                if let foundTuple:(Comment, Int) = dictionaryMap[indexPath.row] {
                    cell.author.text = foundTuple.0.author
                    cell.comment.text = foundTuple.0.commentBodyText
                    cell.leftConstraint.constant = CGFloat(foundTuple.1 * 10)
                }
            
                return cell;
            
            
        }
        
        return UITableViewCell()
    }

    private func doesThisCommentHaveAReply(comment:Comment) -> Bool {

            if let _ = comment.reply {
                return true
            } else {
                return false
            }
        
    }
}

extension PostDetailTableViewController:FavouritesDelegate {
    
    func addToFavourites() {
        if let postToFavourite:Post = post {
            UserSession.sharedInstance.favouritePosts.append(postToFavourite)
        }
        
    }
    
    fileprivate func isPostInFavourites(postToAdd:Post) -> (Bool, Int) {
        for index in 0..<UserSession.sharedInstance.favouritePosts.count {
            let postToCompare = UserSession.sharedInstance.favouritePosts[index]
            if ((postToCompare.title == postToAdd.title) && (postToCompare.author == postToAdd.author) && (postToCompare.thumbnailLinkURL == postToAdd.thumbnailLinkURL) && (postToCompare.creationDatetime == postToAdd.creationDatetime) && (postToCompare.bodyText == postToAdd.bodyText)) {
                return (true, index)
            }
        }
        return (false, 0)
    }
    
    func removeFromFavourites() {
        if let postToAdd:Post = post {
            let result = self.isPostInFavourites(postToAdd: postToAdd)
            if result.0 {
                UserSession.sharedInstance.favouritePosts.remove(at: result.1)
            }
        }
    }
    
}
