//
//  ChannelsViewController.swift
//  PinBoard
//
//  Created by Claire Lu (student LM) on 4/3/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChannelsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    var refreshControl : UIRefreshControl!
    
    @IBOutlet weak var channelCV: UICollectionView!
    
    @IBOutlet weak var channelTableView: UITableView!
    
    let layoutTop = UICollectionViewFlowLayout()
    
    let darkBlue = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 51/255.0, alpha: 1.0)
    let grayBlue = UIColor.init(red: 204, green: 218, blue: 233, alpha: 1.0)
    
    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
   // var countFol = 2
    var count = 5

    
    func countFollowing(completion: @escaping (Bool) -> ()) {
        ref.child("users/\(self.uid!)").observe(.value){(snapshot) in
           let user = snapshot.value as? [String : AnyObject]
           if let users = user {
               for (userKey, userValue) in users {
                   if userKey == "following" {
                       
                       //    print("what's up \(userKey) : \(userValue.count)")
                       if let num = userValue.count {
                           self.count = num
                        print("After update from firebase \(self.count)")
                       }
                   }
                   
               }
           }
           completion(true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("From collectionView: \(count)")
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        // initializing the top collection view for channels
        if collectionView.tag == 0 {
            let cell = channelCV.dequeueReusableCell(withReuseIdentifier: "channelCell2", for: indexPath) as! ChannelCell
                   ref.child("users/\(uid!)").observe(.value){(snapshot) in let elements = snapshot.value as? [String : AnyObject]
                       
                       if let elements1 = elements {
                           //   print("71 why")
                           for (elementName , element) in elements1 {
                               if elementName == "following" {
                                   //    print("74 why")
                                   
                                   guard let element3 = element as? [String] else {return}
                                   cell.profilePicSub.image = UIImage(named: element3[indexPath.row])
                                   /*
                                    for i in element as! [String]{
                                    print("79 why")
                                    print(i)
                                    cell.profilePicSub.image = UIImage(named: i)
                                    }
                                    
                                    */
                               }
                               
                               
                           }
                       }
                       
                   }
                   
                   cell.backgroundColor = grayBlue
                   cell.layer.cornerRadius = 33
                   return cell
        }
        // initializing the posts collection view
        else if collectionView.tag == 1 {
            print("ok")
            let cell = channelTableView.dequeueReusableCell(withIdentifier: "tvCell", for: indexPath) as! ChannelTVCell
        
            let cell2 = cell.channelCVPostsTV.dequeueReusableCell(withReuseIdentifier: "channelPostCell", for: indexPath) as! SimplePostCell
                   ref.child("users/\(uid!)").observe(.value){(snapshot) in let elements = snapshot.value as? [String : AnyObject]
                              
                       if let elements1 = elements {
                           //   print("71 why")
                           for (elementName , element) in elements1 {
                               if elementName == "following" {
                                   //    print("74 why")
                                   
                                   guard let element3 = element as? [String] else {return}
                                   
                                   let channelName = element3[indexPath.row].capitalized
                                   var name: String
                                   
                                // assign a value to name - the name of the channel, with correct capitalization and spelling
                                   if channelName == "Sci1" {
                                       name = "Science"
                                   }
                                   else if channelName == "Comp1" {
                                       name = "Computer Science"

                                   }
                                   else {
                                       let index = channelName.count-1
                                       name = String(channelName.prefix(index))
                                       
                                   }
                                self.ref.child("All Posts").observe(.value) {(snapshot) in let allPostElements = snapshot.value as? [String : AnyObject]
                                    
                                    if let channels = allPostElements {
                                        for (channelName, channelElements) in channels {
                                            if channelName == name {
                                                if let channelPosts = channelElements as? Dictionary<String, Any> {
                                                    for (postItem, postElement) in channelPosts {
                                                        if postItem == "eventTitle" {
                                                            cell2.postTitle.text = postElement as? String
                                                        }
                                                        else if postItem == "pathToImage" {
                                                            
                                                            if let imageString = postElement as? String {
                                                                let url = URL(string: imageString)
                                                                if let data = try? Data(contentsOf: url!) {
                                                                    let postImage: UIImage = UIImage(data: data)!
                                                                    
                                                                    cell2.postImageView.image = postImage

                                                                }
                                                            }
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                   
                               }
                               
                               
                           }
                       }
                       
                   }
            
              return cell2
          }
        else {
            let cell = UICollectionViewCell()
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print("In tableview 94: \(count)")
        return count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = channelTableView.dequeueReusableCell(withIdentifier: "tvCell", for: indexPath) as! ChannelTVCell

        ref.child("users/\(uid!)").observe(.value){(snapshot) in let elements = snapshot.value as? [String : AnyObject]
                   
            if let elements1 = elements {
                //   print("71 why")
                for (elementName , element) in elements1 {
                    if elementName == "following" {
                        //    print("74 why")
                        
                        guard let element3 = element as? [String] else {return}
                        
                        let channelName = element3[indexPath.row].capitalized
                        var name: String
                        
                        if channelName == "Sci1" {
                            name = "Science"
                        }
                        else if channelName == "Comp1" {
                            name = "Computer Science"

                        }
                        else {
                            let index = channelName.count-1
                            name = String(channelName.prefix(index))
                            
                        }
                        cell.channelLabelTV.text = name

                        
                    }
                    
                    
                }
            }
            
        }
        
        return cell
    }
    
    
    override func viewDidLoad() {
        
        countFollowing() {success in
            if success{
                
                self.channelCV.collectionViewLayout = self.layoutTop
                self.layoutTop.itemSize = CGSize(width: 66, height: 66)
                self.layoutTop.scrollDirection = .horizontal
            /*
                self.channelTableView.dataSource = self
                self.channelTableView.delegate = self
              */
                self.channelTableView.reloadData()
                
                print("In viewdidload: \(self.count)")
               
              
                self.channelTableView.rowHeight = 150
                
                super.viewDidLoad()
            } else {
                
            }
        }



      /*
        countFollowing { (countToPass) -> () in
            self.countFol = countToPass
            self.collectionView(self.channelCV, numberOfItemsInSection: self.countFol)
        }
        */
        // Do any additional setup after loading the view.
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
