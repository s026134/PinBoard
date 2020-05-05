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
    let layoutPostCV = UICollectionViewFlowLayout()
    
    let darkBlue = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 51/255.0, alpha: 1.0)
    let grayBlue = UIColor.init(red: 204, green: 218, blue: 233, alpha: 1.0)
    
    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    // var countFol = 2
    var count = 5
    let channelsArr = ["Gaming", "Music", "Math", "Science", "Sports", "Reading", "Computer Science", "TV", "Food", "Miscellaneous"]
    
    //  let layOutPostCV = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        
        //  layoutPostCV.scrollDirection = .horizontal
        LoadingScreen.instance.showLoader()
        countFollowing() {success in
            if success{
                
                self.channelCV.collectionViewLayout = self.layoutTop
                self.layoutTop.itemSize = CGSize(width: 66, height: 66)
                self.layoutTop.scrollDirection = .horizontal
                
                let tableViewCell = self.channelTableView.dequeueReusableCell(withIdentifier: "tvCell") as! ChannelTVCell
                
                self.layoutPostCV.scrollDirection = .horizontal
                
                self.layoutPostCV.itemSize = CGSize(width: 130, height: 130)
                // tableViewCell.channelCVPostsTV.delegate = self
                //   tableViewCell.channelCVPostsTV.dataSource = self
                tableViewCell.channelCVPostsTV.collectionViewLayout = self.layoutPostCV
                
                /*
                 self.layoutPostCV.itemSize = CGSize(width: 10, height: 10)
                 self.layoutPostCV.scrollDirection = .horizontal
                 */
                /*
                 self.channelTableView.dataSource = self
                 self.channelTableView.delegate = self
                 */
                self.channelTableView.reloadData()
                
                print("In viewdidload: \(self.count)")
                
                
                self.channelTableView.rowHeight = 180
                
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
        
        if collectionView.tag == 0 {
            print("From collectionView: \(count)")
            return count
        }
        else if collectionView.tag == 1 {
            // working
            return 6
        }
        else {
            print("not working? 64")
            return 7
        }
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
            // working
            let cell = channelTableView.dequeueReusableCell(withIdentifier: "tvCell", for: indexPath) as! ChannelTVCell
            
            let cell2 = cell.channelCVPostsTV.dequeueReusableCell(withReuseIdentifier: "channelPostCell", for: indexPath) as! SimplePostCell
            
            //
            
            
            ref.child("users/\(uid!)").observe(.value){(snapshot) in let elements = snapshot.value as? [String : AnyObject]
                
                if let elements1 = elements {
                    // working
                    for (elementName , element) in elements1 {
                        if elementName == "following" {
                            // working
                            
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
                            
                           // print(name)
                            //new
                            
                            //start
                            self.ref.child("All Posts/\(name)").observe(.value) {(snapshot) in let channelPostss = snapshot.value as? [String : AnyObject]
                                
                               // print(channelPostss)
                                if let channelPosts = channelPostss {
                                    
                                    
                                    for (postItem, postElement) in channelPosts {
                                        
                                        cell2.postTitle.text = postItem
                                        
                                        for (postAtr, postDes) in postElement as! Dictionary<String, Any> {
                                            // working
                                            if postAtr == "pathToImage" {
                                                // working
                                                if let imageString = postDes as? String {
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
                            /*
                             self.ref.child("All Posts").observe(.value) {(snapshot) in let allPostElements = snapshot.value as? [String : AnyObject]
                             // working
                             if let channels = allPostElements {
                             // working
                             for (theChannel, channelElements) in channels {
                             if theChannel == name {
                             // working
                             if let channelPosts = channelElements as? Dictionary<String, Any> {
                             // working - channel elements is dict
                             //print(channelElements)
                             for (postItem, postElement) in channelPosts {
                             //   print ("post item: \(postItem) and post element: \(postElement)")
                             // postItem should be the title of the post and should be equal to the eventTitle
                             cell2.postTitle.text = postItem
                             // print("this is cell2's text: \(cell2.postTitle.text) | and this is postItem text: \(postItem)")
                             /*
                             if postItem == "eventTitle" {
                             print("136 post item == eventtitle")
                             cell2.postTitle.text = postElement as? String
                             }
                             */
                             for (postAtr, postDes) in postElement as! Dictionary<String, Any> {
                             // working
                             if postAtr == "pathToImage" {
                             // working
                             if let imageString = postDes as? String {
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
                             
                             */
                        }
                        
                        
                    }
                }
                
            }
            LoadingScreen.instance.hideLoader()
            return cell2
        }
            
        else {
            print("in else")
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
    
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
