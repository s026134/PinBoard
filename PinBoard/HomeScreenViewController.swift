//
//  HomeScreenViewController.swift
//  PinBoard
//
//  Created by Claire Lu (student LM) on 2/23/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var posts = [Post]()
    @IBOutlet weak var channelCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    let layout2 = UICollectionViewFlowLayout()
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelCollectionView.collectionViewLayout = layout
        channelCollectionView.delegate = self
        channelCollectionView.dataSource = self
        layout.itemSize = CGSize(width: 65, height: 65)
        layout.scrollDirection = .horizontal
    
        collectionView.collectionViewLayout = layout2
        collectionView.delegate = self
        collectionView.dataSource = self
        layout2.itemSize = CGSize(width:200, height: 200)
        layout2.scrollDirection = .vertical
        
        refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        fetchPosts()
        // Do any additional setup after loading the view.
    }
    
    @objc func handleRefresh(){
        print("refresh!")
    }

    
    func fetchPosts (){
    
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref.child("All Posts/\(uid!)").observe(.value){(snapshot) in
            let allPosts = snapshot.value as? [String : AnyObject]
            
            if let allThePosts = allPosts{
                for(_, post) in allThePosts{
                    let postss = Post()
                    
                    if let attending = post["attending"] as? String,
                    let author = post["author"] as? String,
                    let descrip = post["description"] as? String,
                    let eventDate = post["eventDate"] as? String,
                    let eventTitle = post["eventTitle"] as? String,
                    let location = post["location"] as? String,
                    let pathToImage = post["pathToImage"] as? String,
                        let userID = post["userID"] as? String{
                        
                        postss.attending = attending
                        postss.author = author
                        postss.Descrip = descrip
                        postss.eventDate = eventDate
                        postss.eventTitle = eventTitle
                        postss.location = location
                        postss.pathToimage = pathToImage
                        postss.userID = userID
                        
                        self.posts.append(postss)
                
                        
                    }
                    self.collectionView.reloadData()
                }
            }
            
        }
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            //change this to the number of posts
            return 10
        }
        else{
            //change this to the number of channels that the user is following
            return 20
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
            
        
//            cell.attendingLabel.text = posts[indexPath.row].attending
//            cell.dateLabel.text = posts[indexPath.row].eventDate
//            cell.descriPLabel.text = posts[indexPath.row].Descrip
//            cell.eventTitleLabel.text = posts[indexPath.row].eventTitle
//            cell.locLabel.text = posts[indexPath.row].location
//            cell.postImage.downloadImage(from: posts[indexPath.row].pathToimage)
            
            return cell
        }
            
        else {
            let cell = channelCollectionView.dequeueReusableCell(withReuseIdentifier: "channelCell", for: indexPath)
            cell.backgroundColor = .blue
            cell.layer.cornerRadius = 32
            
            return cell
        }
        
        //ends the refreshing
//        self.refreshControl.endRefreshing()
    }}

extension UIImageView{
    func downloadImage(from imgURL: String!){
        let url = URLRequest(url: ((URL(string: imgURL)))!)
        //        let url = ""
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        
        task.resume()
    }
}

