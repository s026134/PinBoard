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
    
    let mintGreen = UIColor.init(red: 159/255, green: 216/255, blue: 138/255, alpha: 1)
    
    let blue = UIColor.init(red: 28/255, green: 53/255, blue: 130/255, alpha: 1)
    
    let coral = UIColor.init(red: 229/255, green: 88/255, blue: 93/255, alpha: 1)
    
    let lightBlue = UIColor.init(red: 170/255, green: 223/255, blue: 227/255, alpha: 1)
    var selectedCell : PostCell!
    var selectedCellImage : Int!
    
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
        layout2.minimumInteritemSpacing = 1
        layout2.minimumLineSpacing = 10
        
        refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        fetchPosts()
        
    }
    
    @objc func handleRefresh(){
        print("refresh!")
    }
    
    
    func fetchPosts (){
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("All Posts/\(uid!)").observe(.value){(snapshot) in
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
            
            self.collectionView.reloadData()
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            
            
            
        }
        
    }
    
    @IBAction func loggedOutPressed(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "backToMain", sender: self)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            //change this to the number of posts
            return posts.count
        }
        else{
            //change this to the number of channels that the user is following
            return 20
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
            
            if indexPath.row < posts.count{
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
            
        else {
            let cell = channelCollectionView.dequeueReusableCell(withReuseIdentifier: "channelCell", for: indexPath)
            cell.backgroundColor = blue
            cell.layer.cornerRadius = 32
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! PostCell
            selectedCell = cell
            selectedCellImage = indexPath.row
            
            self.performSegue(withIdentifier: "moreDetails", sender: self)
        }
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


extension UIImageView{
    func downloadImage(from imgURL: String!){
        if let imgU = imgURL{
            let url = URLRequest(url: ((URL(string: imgU)))!)
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
}

