//
//  Post.swift
//  Selfiegram
//
//  Created by Kevin Cleathero on 2017-03-01.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Post: PFObject, PFSubclassing {
    //var image: UIImage
    @NSManaged var image:PFFile
    @NSManaged var user: PFUser  //how does it know about my user class wihtout importing or inheriting?
    @NSManaged var comment: String
    
    convenience init(image: PFFile, user: PFUser, comment: String) {
        self.init()
        self.image = image
        self.user = user
        self.comment = comment
    }
    
    var likes: PFRelation<PFObject>! {
        // PFRelations are a bit different from just a regular properties
        // This is called a “computed property”, because it’s value is computed every time instead of stored.
        // The line below specifies that our relation column on Parse should be called “likes”
        return relation(forKey: "likes")
    }
    
   
    static func parseClassName() -> String {
        // sets what the table name on Parse will be called
        return "Post"
    }
}
