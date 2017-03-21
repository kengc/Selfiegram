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
    
//    init(uimageURL: URL, puser: User, pcomment: String) {
//        imageURL = uimageURL
//        user = puser
//        comment = pcomment
//    }
    
    static func parseClassName() -> String {
        // sets what the table name on Parse will be called
        return "Post"
    }
}
