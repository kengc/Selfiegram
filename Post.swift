//
//  Post.swift
//  Selfiegram
//
//  Created by Kevin Cleathero on 2017-03-01.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var image: UIImage
    var user: User  //how does it know about my user class wihtout importing or inheriting?
    var comment: String

    init(uimage: UIImage, puser: User, pcomment: String) {
        image = uimage
        user = puser
        comment = pcomment
    }
}
