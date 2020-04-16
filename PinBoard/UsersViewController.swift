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

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    var checkMarks = [Int: Bool]()
    var channFollowing = [User]()
    let mintGreen = UIColor.init(red: 159/255, green: 216/255, blue: 138/255, alpha: 1)
    
    let blue = UIColor.init(red: 28/255, green: 53/255, blue: 130/255, alpha: 1)
    
    let coral = UIColor.init(red: 229/255, green: 88/255, blue: 93/255, alpha: 1)
    
    let lightBlue = UIColor.init(red: 170/255, green: 223/255, blue: 227/255, alpha: 1)
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    var channelsToSendTo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchFollowing()

        if checkMarks.count != 0{
            var count = 0
            for(row, TorF) in checkMarks{
                if TorF == false{
                    count += 1
                }
            }
            
            if count == checkMarks.count{
                doneButton.isHidden = true
            }
        }
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        for (row, TorF) in checkMarks {
            if TorF == true{
                channelsToSendTo.append(channFollowing[row].channelName)
            }
        }
    
//        performSegue(withIdentifier: "backToPosting", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? PostScreenViewController{
            nextViewController.channelsToSendTo = channelsToSendTo
        }
    }
    
    func fetchFollowing(){
       
        
        ref.child("users/\(uid!)/following").observe(.value){(snapshot) in
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
            
         self.tableView.reloadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channFollowing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannCell", for: indexPath) as! UserCell
        cell.layer.cornerRadius = cell.contentView.frame.height / 2
        cell.backgroundColor = lightBlue
        cell.profImage.image = channFollowing[indexPath.row].imagePath
        cell.profImage.layer.cornerRadius = 48
        cell.channelNameLabel.text = channFollowing[indexPath.row].channelName
        
        
        if checkMarks[indexPath.row] != nil {
            doneButton.isHidden = false
            cell.accessoryType = checkMarks[indexPath.row]! ? .checkmark : .none
        } else {
            checkMarks[indexPath.row] = false
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                checkMarks[indexPath.row] = false
            }
            else{
                cell.accessoryType = .checkmark
                checkMarks[indexPath.row] = true
            }
        }
        self.tableView.reloadData()
    }

    
}
