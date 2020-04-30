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
   let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
         
    @IBOutlet weak var profilePic: UIImageView!
    
//    init(uid: String, email: String, urlToImage: URL, password: String, fullName: String) {
//        self.uid = uid
//        self.email = email
//        self.urlToImage = urlToImage
//        self.password = password
//        self.fullName = fullName
////        self.userTag = userTag
//    }
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
           super.viewDidLoad()
          
        profilePic?.layer.cornerRadius = (profilePic?.frame.size.width ?? 0.0) / 2
          profilePic?.clipsToBounds = true
          profilePic?.layer.borderWidth = 3.0
          profilePic?.layer.borderColor = UIColor.white.cgColor
           fetchImage()
            fetchName()
           // Do any additional setup after loading the view.
       }
    
    @IBAction func signOutWasPressed(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isUserSignedIn")
            self.performSegue(withIdentifier: "fromProfiletoNav", sender: self)
        }catch let signOutError{
            print(signOutError.localizedDescription)
        }
    }
    func fetchName() {
        ref.child("users/\(uid!)").observe(.value){(snapshot) in
            let user = snapshot.value as? [String : AnyObject]
            
            if let aUser = user {
                let name = aUser["User Name"]
                
                if let userName = name as? String {
                    
                   
                    self.userName.text = userName
                    
                    
                }
                
                
                
            }
            
            
        }
        
        
    }
    
    func fetchImage() {
        ref.child("users/\(uid!)").observe(.value){(snapshot) in
            let user = snapshot.value as? [String : AnyObject]
            
            if let aUser = user {
                let image1 = aUser["urlToImage"]
                
                if let image2 = image1 as? String {
                    
                    let url = URL(string: image2)
                    
                    if let data = try? Data(contentsOf: url!) //replaced url! w/ image1!
                    {
                        let imagge: UIImage = UIImage(data: data)!
                        
                        self.profilePic.image = imagge
                    }
                    
                }
                
                
                
            }
            
            
        }
    }
    
    
}
