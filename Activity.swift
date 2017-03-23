//
//  Activity.swift
//  Selfiegram
//
//  Created by Kevin Cleathero on 2017-03-22.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import Foundation
import UIKit
import Parse


class Activity: PFObject, PFSubclassing {
    //var image: UIImage
    @NSManaged var type:String
    @NSManaged var post:Post
    @NSManaged var user:PFUser
    
    convenience init(type:String, post:Post, user:PFUser) {
        self.init()
        self.type = type
        self.post = post
        self.user = user
    }
    
    static func parseClassName() -> String {
        // sets what the table name on Parse will be called
        return "Activity"
    }
}
