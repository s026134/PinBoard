//
//  EventViewController.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 4/6/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EventViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var descrip: UITextView!
    @IBOutlet weak var attendLabel: UILabel!
    @IBOutlet weak var imAge: UIImageView!
    var eventTitle : String!
    @IBOutlet weak var contactInfoLabel: UILabel!
    var eventDate : String!
    var loc : String!
    var Descrip : String!
    var attending : String!
    var imageURL: String!
    var contactInfo : String!
    var fromDashboard: String?
    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    var channFollowing = [User]()
    
    @IBOutlet weak var viewOpac: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingScreen.instance.showLoader()
        descrip.isEditable = false
        
        let blue = UIColor.init(red: 28/255, green: 53/255, blue: 130/255, alpha: 0.2)
        viewOpac.backgroundColor = blue
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        fetchEvent()
        LoadingScreen.instance.hideLoader()
        
    }
    
    @IBAction func attendingPressed(_ sender: UIButton) {
        fetchFollowing()
        for i in channFollowing{
            let keyy = ref.child("All Posts/\(i.channelName!)/\(titleLabel.text!)")
            keyy.observeSingleEvent(of: .value){(snapshot) in
                let postQ = snapshot.value as? [String: Any]
                if postQ != nil{
                    let key = self.ref.child("All Posts/\(i.channelName!)/\(self.titleLabel.text!)/attending")
                    key.observeSingleEvent(of: .value){(snapshot) in
                        
                        let attend = snapshot.value as? Int
                        if let att = attend{
                            print(att)
                            print(i.channelName!)
                            self.attendLabel.text = "\(att + 1)"
                            key.setValue(att + 1)
                            
                            let thirdkey = self.ref.child("All Posts/\(self.uid!)/\(self.titleLabel.text!)")
                            let keyz = self.ref.child("All Posts/\(i.channelName!)/\(self.titleLabel.text!)")
                            keyz.observeSingleEvent(of: .value){(snapshot) in
                                let poz = snapshot.value as? [String: Any]
                                thirdkey.setValue(poz!)
                            }
                        }
                        
                        
                    }
                    
                    let secondkey = self.ref.child("All Posts/\(postQ!["userID"]!)/\(self.titleLabel.text!)/attending")
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
    
    func fetchEvent(){
        if fromDashboard != nil{
                ref.child("All Posts/\(uid!)/\(fromDashboard!)").observe(.value){(snapshot) in
                    let elements = snapshot.value as? [String: Any]
                    if let element = elements{
                        for (ele, val) in element{
                            if ele == "attending"{
                                print(val)
                                self.attendLabel.text = "\(val as! Int)"
                            }
                            else if ele == "description"{
                                self.descrip.text = val as? String
                            }
                            else if ele == "eventDate"{
                                self.dateLabel.text = val as? String
                            }
                            else if ele == "eventTitle"{
                                self.titleLabel.text = val as? String
                            }
                            else if ele == "location"{
                                self.location.text = val as? String
                            }
                            else if ele == "contactInfo"{
                                self.contactInfoLabel.text = val as? String
                            }
                            else if ele == "pathToImage"{
                                self.imAge.downloadImage(from: val as? String)
                            }
                            else if ele == "contactInfo"{
                                self.contactInfoLabel.text = val as? String
                            }
                        }
                    }
            }
        }
            
        else{
            titleLabel.text = eventTitle
            dateLabel.text = eventDate
            location.text = loc
            descrip.text = Descrip
            attendLabel.text = attending
            contactInfoLabel.text = contactInfo
            imAge.downloadImage(from: imageURL)
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

