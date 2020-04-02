//
//  UserProfile.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 3/23/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class UserProfile: UIViewController {
//
//    var uid: String
//    var email: String
//    var urlToImage: URL
//    var password: String
//    var fullName: String
//    var userTag: Set<Int>
//    , userTag: Set<Int>
   
    @IBOutlet weak var profilePic: UIImageView!
    
//    init(uid: String, email: String, urlToImage: URL, password: String, fullName: String) {
//        self.uid = uid
//        self.email = email
//        self.urlToImage = urlToImage
//        self.password = password
//        self.fullName = fullName
////        self.userTag = userTag
//    }
    override func viewDidLoad() {
           super.viewDidLoad()
          
           fetchImage()
           // Do any additional setup after loading the view.
       }
    func fetchImage() {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref.child("users/\(uid!)").observe(.value){(snapshot) in
                   let user = snapshot.value as? [String : AnyObject]
           
            if let aUser = user {
                let image1 = aUser["urlToImage"]
 
                let url = URL(string: image1 as! String)
               
                    if let data = try? Data(contentsOf: url!) //replaced url! w/ image1!
                    {
                        let imagge: UIImage = UIImage(data: data)!
                        self.profilePic.image = imagge
                    }
                
            }
            
            
        }
    }
 
}
