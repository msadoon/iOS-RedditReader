//
//  Subreddit.swift
//  CoupgonCodingChallenge
//
//  Created by Mubarak Sadoon on 2017-04-28.
//  Copyright © 2017 Coupgon. All rights reserved.
//

import Foundation

class Subreddit {
    
    var name:String?
    var url:String?
    
    convenience init(name:String?, url:String?) {
        self.init()
        
        if let nameToUse:String = name {
                self.name = nameToUse
        } else {
            self.name = ""
        }

        
        if let urlToUse:String = url {
            self.url = urlToUse
        } else {
            self.url = ""
        }
        
    }
    
}
