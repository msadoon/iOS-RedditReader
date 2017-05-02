//
//  Comment.swift
//  CoupgonCodingChallenge
//
//  Created by Mubarak Sadoon on 2017-04-28.
//  Copyright © 2017 Coupgon. All rights reserved.
//

import Foundation

class Comment {
    
    var commentBodyText:String?
    var author:String?
    var reply:Comment?
    
    convenience init(author:String?, commentBodyText:String?) {
        self.init()
        
        if let authorToUse:String = author {
            self.author = authorToUse
        } else {
            self.author = ""
        }
        
        if let commentToUse:String = commentBodyText {
            self.commentBodyText = commentToUse
        } else {
            self.commentBodyText = ""
        }
        
    }
    
}
