//
//  UserService.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 3/23/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static var currentUserProfile: UserProfile?
    
    static func observeUserProfile(_uid: String, completion: @escaping ((_ userProfile: UserProfile?) -> ())){
        
        let userRef = Database.database().reference().child("users/profile\(Auth.auth().currentUser?.uid)")
        
        userRef.observe(.value, with: { snapshot in
            
            var userProfile : UserProfile?
            
            if let dict = snapshot.value as? [String: Any],
                let email = dict["email"] as? String,
                let password = dict["password"] as? String,
//                let userTag = dict["userTag"] as? Set<Int>,
                let fullName = dict["fullName"] as? String,
                let urlToImage = dict["urlToImage"] as? String,
                let url = URL(string: urlToImage){
                
//                , userTag: userTag
                userProfile = UserProfile(uid: snapshot.key, email: email, urlToImage: url, password: password, fullName: fullName)
                
            
                }
            
            completion(userProfile)
            
            
        })
        
    }
}
