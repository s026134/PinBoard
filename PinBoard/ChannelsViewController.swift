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
    var countFol = 2
    var count = 5
    
    //   let channels = ["Gaming": game, "Music": music, "Math": math, "Science": science, "Sports": " ", "Reading": " ", "Computer Science": " ", "TV": " ", "Food": " ", "Misc": " "]
    /*
    func countFollowing (completion: @escaping ((Int) -> Void)) -> Int {
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global()
        var count = 3
        
        queue.async {
            //  completion("")
            
            self.ref.child("users/\(self.uid!)").observe(.value){(snapshot) in
                let user = snapshot.value as? [String : AnyObject]
                if let users = user {
                    for (userKey, userValue) in users {
                        if userKey == "following" {
                            
                            //    print("what's up \(userKey) : \(userValue.count)")
                            if let num = userValue.count {
                                count = num
                                print("line 50 \(count)")
                            }
                            
                            
                        }
                        
                    }
                }
                
            }
            completion(count)
            semaphore.signal()
            
        }
       // let _ = semaphore.wait(timeout: .now() + 5.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            //this code will be executed only after 2 seconds have been passed
            return 5
        }
        queue.async {
            //  completion("Line 65: count = \(count)")
            return completion(count)
        }
        
        
        
        //   return 5a
        
    }
 
    func asyncMethod(completion: (String) -> Void) {
        sleep(2)
        completion("done")
    }
 */

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
        

        
        
//        var followingCount: Int
//        countFollowing()
//        let semaphore = DispatchSemaphore(value: 0)
//        let queue = DispatchQueue.global()
  /*
        queue.async {
            self.countFollowing { (countToPass) -> () in
                self.countFol = countToPass
            }
            semaphore.signal()
        }
        
        */
        // print("line 61 \(count)")
        
        // trying to pass something
        /*
        countFollowing { (countToPass) -> () in
            self.countFol = countToPass
            self.collectionView(self.channelCV, numberOfItemsInSection: self.countFol)
        }
 */
      //  return countFol
        print("From collectionView: \(count)")
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
        
        countFollowing() {success in
            if success{
                
                self.channelCV.collectionViewLayout = self.layoutTop
                self.layoutTop.itemSize = CGSize(width: 66, height: 66)
                self.layoutTop.scrollDirection = .horizontal
                
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
