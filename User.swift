//
//  User.swift
//  Selfiegram
//
//  Created by Kevin Cleathero on 2017-03-01.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import Foundation
import UIKit

class User {
    let userName: String
    var profileImage: UIImage
    
    init(uname: String, pimage: UIImage) {
        userName = uname
        profileImage = pimage
    }
}
