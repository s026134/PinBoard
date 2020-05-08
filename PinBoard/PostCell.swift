//
//  PostCell.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 3/23/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PostCell: UICollectionViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var userPostedLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriPLabel: UILabel!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var attendingLabel: UILabel!
    var channFollowing = [User]()
    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    var contactInfo : String!

    @IBAction func attendPressed(_ sender: UIButton) {
        
        fetchFollowing()
        for i in channFollowing{
            let keyy = ref.child("All Posts/\(i.channelName!)/\(eventTitleLabel.text!)")
            keyy.observeSingleEvent(of: .value){(snapshot) in
                let postQ = snapshot.value as? [String: Any]
                if postQ != nil{
                    let key = self.ref.child("All Posts/\(i.channelName!)/\(self.eventTitleLabel.text!)/attending")
                    key.observeSingleEvent(of: .value){(snapshot) in
                        
                        let attend = snapshot.value as? Int
                        if let att = attend{
                            print(att)
                            print(i.channelName!)
                            self.attendingLabel.text = "\(att + 1)"
                            key.setValue(att + 1)
                            
                            let thirdkey = self.ref.child("All Posts/\(self.uid!)/\(self.eventTitleLabel.text!)")
                            let keyz = self.ref.child("All Posts/\(i.channelName!)/\(self.eventTitleLabel.text!)")
                            keyz.observeSingleEvent(of: .value){(snapshot) in
                                let poz = snapshot.value as? [String: Any]
                                thirdkey.setValue(poz!)
                            }
                        }
                        
                        
                    }

                    let secondkey = self.ref.child("All Posts/\(postQ!["userID"]!)/\(self.eventTitleLabel.text!)/attending")
                    secondkey.observeSingleEvent(of: .value){(snapshot) in
                        
                        let attend = snapshot.value as? Int
                        if let att = attend{
                            print(att)
                            secondkey.setValue(att + 1)
                        }
                        
                    }
                }
                
            }
        
            
            
        }
        
    }
    
    func fetchFollowing(){
        
        ref.child("users/\(uid!)/following").observeSingleEvent(of: .value){(snapshot) in
            let following = snapshot.value as? [String]
            
            var num : User?
            let channelDict = ["gaming1" : "Gaming", "music1": "Music", "math1" : "Math", "sci1": "Science", "sports1": "Sports", "reading1" : "Reading", "comp1": "Computer Science", "tv1": "TV Shows", "food1": "Food", "mis1" : "Miscellaneous"]
            
            
            if let follow = following{
                for i in follow{
                    if self.channFollowing.count > 0{
                        for j in self.channFollowing{
                            if j.channelName == i{
                                num = j
                                
                            }
                        }
                    }
                    if num == nil{
                        self.channFollowing.append(User())
                        if let som = self.channFollowing.last{
                            som.channelName = channelDict[i]
                            som.imagePath = UIImage(named: i)
                        }
                        
                    }
                    
                }
                
            }
        }
        //  print(self.channFollowing)
    }

}
