//
//  Post.swift
//  CoupgonCodingChallenge
//
//  Created by Mubarak Sadoon on 2017-04-28.
//  Copyright © 2017 Coupgon. All rights reserved.
//

import Foundation

class Post {
    
    var title:String?
    var author:String?
    var creationDatetime:String?
    var thumbnailLinkURL:String?
    var bodyText:String?
    var permalink:String?
    var favourite:Bool = false;
    
    convenience init(title:String?, author:String?, creationDatetime:String?, bodyText:String?, thumbnailLinkURL:String?, permalink:String?) {
        self.init()
        
        if let titleToUse:String = title {
            self.title = titleToUse
        } else {
            self.title = ""
        }
        
        if let commentLinkToUse:String = permalink {
            self.permalink = commentLinkToUse
        } else {
            self.permalink = ""
        }
        
        if let authorToUse:String = author {
            self.author = authorToUse
        } else {
            self.author = ""
        }
        
        if let creationDatetimeToUse:String = creationDatetime {
            self.creationDatetime = creationDatetimeToUse
        } else {
            self.creationDatetime = ""
        }
        
        if let thumbnailPreviewURLToUse:String = thumbnailLinkURL {
            self.thumbnailLinkURL = thumbnailPreviewURLToUse
        } else {
            self.thumbnailLinkURL = ""
        }
        
        if let bodyTextToUse:String = bodyText {
            self.bodyText = bodyTextToUse
        } else {
            self.bodyText = ""
        }
        
    }
    
    
}
