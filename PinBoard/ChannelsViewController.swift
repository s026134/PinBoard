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
    var count = 5
    
    
 //   let channels = ["Gaming": game, "Music": music, "Math": math, "Science": science, "Sports": " ", "Reading": " ", "Computer Science": " ", "TV": " ", "Food": " ", "Misc": " "]
    func countFollowing () {
        
        ref.child("users/\(uid!)").observe(.value){(snapshot) in
        let user = snapshot.value as? [String : AnyObject]
            if let users = user {
                for (userKey, userValue) in users {
                    if userKey == "following" {
                       
                        print("what's up \(userKey) : \(userValue.count)")
                        if let num = userValue.count {
                            self.count = num
                            print(self.count)
                        }
                    
                    
                    }
                
                }
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // this is supposed to count the number of channels you're following but it doesn't work! ah! - Claire
        
        countFollowing()
        
        
        print(count)
        return count
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       let cell = channelCV.dequeueReusableCell(withReuseIdentifier: "channelCell2", for: indexPath) as! ChannelCell
        ref.child("users/\(uid!)").observe(.value){(snapshot) in let elements = snapshot.value as? [String : AnyObject]
            
            if let elements1 = elements {
                print("71 why")
                for (elementName , element) in elements1 {
                    if elementName == "following" {
                        print("74 why")
                        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
                
        return cell
    }
    

  
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countFollowing()

        channelCV.collectionViewLayout = layoutTop
        layoutTop.itemSize = CGSize(width: 66, height: 66)
        layoutTop.scrollDirection = .horizontal
        
       
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
