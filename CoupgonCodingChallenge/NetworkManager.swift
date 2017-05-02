//
//  NetworkManager.swift
//  CoupgonCodingChallenge
//
//  Created by Mubarak Sadoon on 2017-04-30.
//  Copyright © 2017 Coupgon. All rights reserved.
//

import Foundation
import Alamofire

public class NetworkManager {
    
    static var sharedInstance = NetworkManager.init()
    
    init() {
       UserSession.sharedInstance.initializeUser()
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    func getAllSubreddits(completion:@escaping (_ success:Bool) -> ()) {
        Alamofire.request("https://www.reddit.com/r/subreddits.json?limit=100").validate().responseJSON { response in
                switch response.result {
                case .success:
                    print("validation success.")
                    UserSession.sharedInstance.initializeSubreddits()
                    
                    guard let toplevelData = response.result.value as? [String:AnyObject] else {
                        return
                    }
                    
                    guard let nextLevelData = toplevelData["data"] as? [String:AnyObject] else {
                        return
                    }
                    
                    guard let childData = nextLevelData["children"] as? [[String:AnyObject]] else {
                        return
                    }
                    
                    for child in childData  {
                        if let childToPass = child["data"] as? [String:AnyObject] {
                            
                                guard let notsafeForWork:Bool = childToPass["over_18"] as? Bool else {
                                    continue
                                }
                            
                                if notsafeForWork {
                                    continue
                                }
                                
                                var dictionaryBuilder:[String:String] = ["thumbnailPreviewURL":"","name":"","url":""]
                            
                            
                                if let name = childToPass["title"] as? String {
                                    dictionaryBuilder["name"] = name
                                }
                            
                                guard let url = childToPass["url"] as? String else {
                                    continue
                                }
                            
                                if url.lowercased().range(of: "comments") != nil {
                                    continue //we dont want subreddits that are comments.
                                }
                            
                                if let rangeOfLink = url.range(of: "https://www.reddit.com/r/", options: .backwards) {
                             
                                    //basically only want subreddits with a proper subreddit url. Both to give the subreddit titles and to get back posts using this URL.
                                    
                                    let stringWithSlash = String(url.characters.suffix(from: rangeOfLink.upperBound))
                                    
                                    if stringWithSlash.characters.last != nil {
                                        if stringWithSlash.characters.last! == "/" {
                                            dictionaryBuilder["url"] = stringWithSlash.substring(to: stringWithSlash.index(before: stringWithSlash.endIndex))
                                            self.addSubredditToCurrentUser(child: dictionaryBuilder)
                                        } else {
                                            dictionaryBuilder["url"] = stringWithSlash
                                            self.addSubredditToCurrentUser(child: dictionaryBuilder)
                                        }
                                    }
                                    
                                }
     
     
                            
                        }
                    }
                    
                    completion(true)
                    
                case .failure(let error):
                    print(error)
                    completion(false)
                }
            }
    }
    
    private func addSubredditToCurrentUser(child:[String:String]) {
        
        let subredditToAddToUser = Subreddit(name: child["name"], url: child["url"])
        
        UserSession.sharedInstance.user1.subreddits?.append(subredditToAddToUser)
    }
    
    private func addPostToCurrentUser(child:[String:String]) {
        
        let postToAddToUser = Post(title: child["title"], author: child["author"], creationDatetime: child["createTime"], bodyText: child["bodyText"], thumbnailLinkURL: child["thumbnailURL"], permalink: child["permalink"])
  
        UserSession.sharedInstance.user1.subredditPosts?.append(postToAddToUser)
    }
    
    func getPosts(subredditName:String, completion:@escaping (_ success:Bool) -> ()) {
        Alamofire.request("https://www.reddit.com/r/\(subredditName).json").validate().responseJSON { response in
            switch response.result {
            case .success:
                print("validation success.")
                UserSession.sharedInstance.initializePosts()
                
                guard let toplevelData = response.result.value as? [String:AnyObject] else {
                    return
                }
                
                guard let nextLevelData = toplevelData["data"] as? [String:AnyObject] else {
                    return
                }
                
                guard let childData = nextLevelData["children"] as? [[String:AnyObject]] else {
                    return
                }
                
                for child in childData  {
                    if let childToPass = child["data"] as? [String:AnyObject] {
                        
                        guard let notsafeForWork:Bool = childToPass["over_18"] as? Bool else {
                            continue
                        }
                        
                        if notsafeForWork {
                            continue
                        }
                        
                        var dictionaryBuilder:[String:String] = ["title":"",
                                                                 "author":"",
                                                                 "createTime":"",
                                                                 "thumbnailURL":"",
                                                                 "bodyText":"",
                                                                 "permalink":""]
                        
                        if let title = childToPass["title"] as? String {
                            dictionaryBuilder["title"] = title
                        }
                        
                        if let author = childToPass["author"] as? String {
                            dictionaryBuilder["author"] = author
                        }
                        
                        if let selfText = childToPass["selftext"] as? String {
                            dictionaryBuilder["bodyText"] = selfText
                        }
                        
                        if let selfText = childToPass["permalink"] as? String {
                            dictionaryBuilder["permalink"] = selfText
                        }
                        
                        if let createTime = childToPass["created"] as? UIntMax {
                            let timeInt = TimeInterval(createTime)
                            let date:Date = Date(timeIntervalSince1970: timeInt)
                            let formatter = DateFormatter()
                            formatter.dateStyle = DateFormatter.Style.long
                            formatter.timeStyle = .medium
                            let dateString = formatter.string(from: date)
                        
                            dictionaryBuilder["createTime"] = "\(dateString)"
                        }
                        
                        if let mediaValue:String = childToPass["thumbnail"] as? String {
                            dictionaryBuilder["thumbnailURL"] = mediaValue
                            
                        }

                        self.addPostToCurrentUser(child: dictionaryBuilder)
                        
                    }
                }
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    private func parseComment(childToPass:[String:AnyObject], comment:Comment?) -> Comment {
        
        var newComment:Comment?

            var dictionaryBuilder:[String:String] = ["commentText":"",
                                                     "author":""]
            
            if let commentText = childToPass["body"] as? String {
                dictionaryBuilder["commentText"] = commentText
            }
            
            if let author = childToPass["author"] as? String {
                dictionaryBuilder["author"] = author
            }
            
            guard let replies = childToPass["replies"] as? [String:AnyObject] else {
                newComment = Comment(author: dictionaryBuilder["author"], commentBodyText: dictionaryBuilder["commentText"])
                return newComment!
            }
            
            guard let repliesSecondLevel = replies["data"] as? [String:AnyObject] else {
                newComment = Comment(author: dictionaryBuilder["author"], commentBodyText: dictionaryBuilder["commentText"])
                return newComment!
            }
            
            guard let repliesThirdLevel = repliesSecondLevel["children"] as? [[String:AnyObject]] else {
                newComment = Comment(author: dictionaryBuilder["author"], commentBodyText: dictionaryBuilder["commentText"])
                return newComment!
            }
            
            if let repliesFourthLevel:[String:AnyObject] = repliesThirdLevel[0]["data"] as? [String:AnyObject] {
                newComment = Comment(author: dictionaryBuilder["author"], commentBodyText: dictionaryBuilder["commentText"])
                newComment?.reply = parseComment(childToPass: repliesFourthLevel, comment: newComment)
                return newComment!
            } else {
                newComment = Comment(author: dictionaryBuilder["author"], commentBodyText: dictionaryBuilder["commentText"])
                return newComment!
            }


    }
    
    func getComments(commentLink:String, completion:@escaping (_ success:Bool, _ comment:[Comment]) -> ()) {
        Alamofire.request("https://www.reddit.com\(commentLink).json").validate().responseJSON { response in
            switch response.result {
            case .success:
                print("validation success.")
                UserSession.sharedInstance.initializeComments()
                
                guard let toplevelData = response.result.value as? [[String:AnyObject]] else {
                    return
                }
                
                let secondTierTopLevelData:[String:AnyObject] = toplevelData[1]
                
                guard let nextLevelData = secondTierTopLevelData["data"] as? [String:AnyObject] else {
                    return
                }
                
                guard let childData = nextLevelData["children"] as? [[String:AnyObject]] else {
                    return
                }
                
                var commentsToPassBack:[Comment] = []
                
                for child in childData  {
                    if let childToPass = child["data"] as? [String:AnyObject] {
                        
                       commentsToPassBack.append(self.parseComment(childToPass: childToPass, comment: nil))
                        
                    }
                }
                
                completion(true, commentsToPassBack)
                
            case .failure(let error):
                print(error)
                
                completion(false, [])
            }
        }
    }
    
}
