//
//  HomeScreenViewController.swift
//  PinBoard
//
//  Created by Claire Lu (student LM) on 2/23/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
        // Do any additional setup after loading the view.
    }
    var posts = [Post]()
    //    var following = [String]()
    
    func fetchPosts (){
        let postss = Post()
        postss.attending = 100
        postss.eventTitle = "Crying"
        self.posts.append(postss)
        
        let ref = Database.database().reference().child("posts")
        
        ref.observe(.value, with: {snapshot in
            for child in snapshot.children{
                
                if let childSnapShot = child as? DataSnapshot,
                    let dict = childSnapShot.value as? [String: Any],
                    let author = dict["author"] as? [String: Any],
                    let uid = dict["uid"] as? String,
                    let email = dict["email"] as? String,
                    let password = dict["password"] as? String,
//                    let userTag = dict["userTag"] as? Set<Int>,
                    let fullName = dict["fullName"] as? String,
                    let urlToImage = dict["urlToImage"] as? String,
                    let url = URL(string: urlToImage),
                    let attending = dict["attending"] as? Int,
                    let pathToimage = dict["pathToImage"] as? String,
                    let location = dict["location"] as? String,
                    let eventTitle = dict["eventTitle"] as? String,
                    let Descrip = dict["description"] as? String,
                    let eventDate = dict["eventDate"] as? String
                {
//                    , userTag: userTag
//                    let userProfile = UserProfile(uid: uid, email: email, urlToImage: url, password: password, fullName: fullName)
                    let postss = Post()
//                    postss.author = userProfile
                    postss.attending = attending
                    postss.pathToimage = pathToimage
                    postss.userID = uid
                    postss.eventTitle = eventTitle
                    postss.location = location
                    postss.Descrip = Descrip
                    postss.eventDate = eventDate
                
                    self.posts.append(postss)
                    print(self.posts)
                }
                
                self.collectionView.reloadData()
            }
            
        })
        
        
        //        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: {
        //            snapshot in
        //
        //            let users = snapshot.value as! [String: AnyObject]
        //
        //            for(_,value) in users{
        //                if let uid = value["uid"] as? String{
        //                    if uid == Auth.auth().currentUser?.uid{
        //                        if let followingUsers = value["following"] as? [String: String]{
        //                            for(_,user) in followingUsers{
        //                                self.following.append(user)
        //                            }
        //                        }
        //                        self.following.append(Auth.auth().currentUser!.uid)
        //                        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: {
        //                            (snap) in
        //
        //                            let postsSnap = snap.value as! [String: AnyObject]
        //
        //                            for (_, post) in postsSnap{
        //                                if let userID = post["userID"] as? String{
        //                                    for each in self.following{
        //                                        if each == userID{
        //                                            let posst = Post()
        //                                            if let author = post["author"] as? String, let attending = post["attending"] as? Int, let pathToImage = post["pathToImage"] as? String, let postID = post["postID "] as? String, let location = post["location"] as? String, let eventTitle = post["eventTitle"] as? String, let Descrip = post["description"] as? String, let eventDate = post["eventDate"] as? String{
        //
        //                                                posst.userPosted = author
        //                                                posst.attending = attending
        //                                                posst.pathToimage = pathToImage
        //                                                posst.postID = postID
        //                                                posst.location = location
        //                                                posst.eventTitle = eventTitle
        //                                                posst.Descrip = Descrip
        //                                                posst.eventDate = eventDate
        //
        //                                                self.posts.append(posst)
        //                                            }
        //                                        }
        //                                    }
        //
        //                                    self.collectionView.reloadData()
        //                                }
        //                            }
        //                        })
        //                    }
        //
        //                }
        //            }
        //        })
        
        ref.removeAllObservers()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        
        //creating the cell
        cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToimage)
        //        cell.userProfileImg.downloadImage(from: self.posts[indexPath.row])
//        cell.userPostedLabel.text = self.posts[indexPath.row].auth
        cell.attendingLabel.text = "\(self.posts[indexPath.row].attending!) Attending"
        cell.dateLabel.text = "Date: \(self.posts[indexPath.row].eventDate)"
        cell.descriPLabel.text = "Description: \(self.posts[indexPath.row].Descrip)"
        cell.locLabel.text = "Location: \(self.posts[indexPath.row].location)"
        
        
        
        return cell
    }}
