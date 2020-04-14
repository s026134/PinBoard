//
//  UsersViewController.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 3/7/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var channFollowing = [User]()
    let mintGreen = UIColor.init(red: 159/255, green: 216/255, blue: 138/255, alpha: 1)
    
    let blue = UIColor.init(red: 28/255, green: 53/255, blue: 130/255, alpha: 1)
    
    let coral = UIColor.init(red: 229/255, green: 88/255, blue: 93/255, alpha: 1)
    
    let lightBlue = UIColor.init(red: 170/255, green: 223/255, blue: 227/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchFollowing()
        print(self.channFollowing)
    
    }
    
    func fetchFollowing(){
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users/\(uid!)/following").observe(.value){(snapshot) in
            let following = snapshot.value as? [String]
            
            var num : User?
            let channelDict = [0 : UIImage(named: "gaming1"), 1: UIImage(named: "music1"), 2: UIImage(named: "math1"), 3: UIImage(named: "sci1"), 4: UIImage(named: "sports1"), 5: UIImage(named: "reading1"), 6: UIImage(named: "comp1"), 7: UIImage(named: "tv1"), 8: UIImage(named: "food1"), 9 : UIImage(named: "mis1")]
            
            
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
                            som.channelName = i
                            som.imagePath = UIImage(named: i)
                        }
                        
                    }
                    
                }
                
            }
            
         self.tableView.reloadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channFollowing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannCell", for: indexPath) as! UserCell
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 3
        cell.layer.borderColor = blue.cgColor
        cell.profImage.image = channFollowing[indexPath.row].imagePath
        cell.channelNameLabel.text = channFollowing[indexPath.row].channelName
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
    }
    
}
