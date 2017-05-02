//
//  SubredditsTableViewController.swift
//  CoupgonCodingChallenge
//
//  Created by Mubarak Sadoon on 2017-04-28.
//  Copyright © 2017 Coupgon. All rights reserved.
//

import UIKit
import SDWebImage

class SubredditsTableViewController: UITableViewController {

    var localSubreddits:[Subreddit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 175
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.title = "Subreddits"
        
        let newFavouriteNavItem = UIBarButtonItem(title: "Favourites", style: UIBarButtonItemStyle.plain, target: self, action: #selector(launchFavouritesView))
        
        self.navigationItem.rightBarButtonItem = newFavouriteNavItem
        
        NetworkManager.sharedInstance.getAllSubreddits() { (success) in
            if (success) {
                self.subredditsFound()
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func launchFavouritesView() {
        
        let modalVC = storyboard?.instantiateViewController(withIdentifier: "FavsId") as! FavouritesTableViewController
        
        self.navigationController?.present(modalVC, animated: true, completion: {
            //complete
        })
    }
    
    private func subredditsFound() {
        if let subreddits = UserSession.sharedInstance.user1.subreddits {
            localSubreddits = subreddits
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return localSubreddits.count
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostsTableViewControllerID") as! PostsTableViewController
        
        vc.subreddit = localSubreddits[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SubredditTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "SubredditCellID") as! SubredditTableViewCell
        cell.selectionStyle = .default
        cell.descriptionLabel.text = localSubreddits[indexPath.row].name
        
        let placeholderImage = UIImage(named: "placeholder")

        return cell;
        
    }
}

