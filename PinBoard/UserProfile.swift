//
//  UserProfile.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 3/23/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import Foundation

class UserProfile{
    
    var uid: String
    var email: String
    var urlToImage: URL
    var password: String
    var fullName: String
//    var userTag: Set<Int>
//    , userTag: Set<Int>
    
    init(uid: String, email: String, urlToImage: URL, password: String, fullName: String) {
        self.uid = uid
        self.email = email
        self.urlToImage = urlToImage
        self.password = password
        self.fullName = fullName
//        self.userTag = userTag
    }
}
