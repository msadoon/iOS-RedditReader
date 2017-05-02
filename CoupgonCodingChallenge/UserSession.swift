//
//  UserSession.swift
//  CoupgonCodingChallenge
//
//  Created by Mubarak Sadoon on 2017-04-30.
//  Copyright © 2017 Coupgon. All rights reserved.
//

import UIKit

public class UserSession {
    
    static var sharedInstance = UserSession.init()
    
    var user1:User = User()
    
    var favouritePosts:[Post] = []
    
    func initializeUser() {
        user1.subreddits = []
        user1.subreddit = Subreddit()
        user1.subredditPosts = []
        user1.post = Post()
        user1.comments = []
    }
    
    func initializeSubreddits() {
        user1.subreddits = []
    }
    
    func initializePosts() {
        user1.subredditPosts = []
    }
    
    func initializeComments() {
        user1.comments = []
    }
    
    
}
