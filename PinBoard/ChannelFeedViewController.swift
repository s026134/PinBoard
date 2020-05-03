//
//  ChannelFeedViewController.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 4/22/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChannelFeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var channelNameLabel: UILabel!
    var name: String!
    @IBOutlet weak var collectionView: UICollectionView!
    var posts = [Post]()
    
    let mintGreen = UIColor.init(red: 159/255, green: 216/255, blue: 138/255, alpha: 1)
    
    let blue = UIColor.init(red: 28/255, green: 53/255, blue: 130/255, alpha: 1)
    
    let coral = UIColor.init(red: 229/255, green: 88/255, blue: 93/255, alpha: 1)
    
    let lightBlue = UIColor.init(red: 170/255, green: 223/255, blue: 227/255, alpha: 1)
    
    let layout = UICollectionViewFlowLayout()
    var refreshControl : UIRefreshControl!
    var selectedCell : PostCell!
    var selectedCellImage : Int!
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        channelNameLabel.text = name
        
        collectionView.collectionViewLayout = layout
        layout.itemSize = CGSize(width: 414, height:  494)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 10
        
        refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(ChannelFeedViewController.fetchPosts), for: .valueChanged)
        
        fetchPosts()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func fetchPosts(){
        ref.child("All Posts/\(name!)").observe(.value){(snapshot) in
            let allPosts = snapshot.value as? [String : AnyObject]
            var posty : Post?
            
            if let allThePosts = allPosts{
                for(postName, post) in allThePosts{
                    for i in self.posts{
                        if i.eventTitle as! String == postName as! String{
                            posty = i
                        }
                    }
                    if posty != nil{
                        if let pos = posty{
                            for (category, element) in post as! [String: AnyObject]{
                                if category == "pathToImage" {
                                    pos.pathToimage = element
                                }
                                else if category == "eventDate"{
                                    pos.eventDate = element
                                }
                                else if category == "attending"{
                                    pos.attending = element
                                }
                                else if category == "description"{
                                    pos.Descrip = element
                                }
                                else if category == "eventTitle"{
                                    pos.eventTitle = element
                                }
                                else if category == "userID"{
                                    pos.userID = element
                                }
                                else if category == "location"{
                                    pos.location = element
                                }
                                else if category == "userName"{
                                    pos.userName = element
                                }
                            }
                        }
                    }
                        
                    else{
                        self.posts.append(Post())
                        if let pos = self.posts.last{
                            for (category, element) in post as! [String: AnyObject]{
                                if category == "pathToImage" {
                                    pos.pathToimage = element
                                }
                                else if category == "eventDate"{
                                    pos.eventDate = element
                                }
                                else if category == "attending"{
                                    pos.attending = element
                                }
                                else if category == "description"{
                                    pos.Descrip = element
                                }
                                else if category == "eventTitle"{
                                    pos.eventTitle = element
                                }
                                else if category == "userID"{
                                    pos.userID = element
                                }
                                else if category == "location"{
                                    pos.location = element
                                }
                                else if category == "userName"{
                                    pos.userName = element
                                }
                            }
                        }
                    }
                    
                }
                
            }
            
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        
        if indexPath.row < posts.count{
            print(posts[indexPath.row].userName)
            cell.userPostedLabel.text = posts[indexPath.row].userName as? String
            cell.attendingLabel.text = "\(posts[indexPath.row].attending as! Int)"
            cell.dateLabel.text = posts[indexPath.row].eventDate as? String
            cell.descriPLabel.text = posts[indexPath.row].Descrip as? String
            cell.eventTitleLabel.text = posts[indexPath.row].eventTitle as? String
            cell.locLabel.text = posts[indexPath.row].location as? String
            cell.postImage.downloadImage(from: posts[indexPath.row].pathToimage as? String)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PostCell
        selectedCell = cell
        selectedCellImage = indexPath.row
        
        self.performSegue(withIdentifier: "moreD", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? EventViewController{
            nextViewController.eventTitle = selectedCell.eventTitleLabel.text
            nextViewController.eventDate = selectedCell.dateLabel.text
            nextViewController.loc = selectedCell.locLabel.text
            nextViewController.Descrip = selectedCell.descriPLabel.text
            nextViewController.attending = selectedCell.attendingLabel.text
            nextViewController.imageURL = posts[selectedCellImage].pathToimage as? String
        }
    }

}
