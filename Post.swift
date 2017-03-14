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
    //var image: UIImage
    var imageURL:URL
    var user: User  //how does it know about my user class wihtout importing or inheriting?
    var comment: String

    init(uimageURL: URL, puser: User, pcomment: String) {
        imageURL = uimageURL
        user = puser
        comment = pcomment
    }
}
