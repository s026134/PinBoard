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
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        retrieveUsers()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
    }
    func retrieveUsers(){
        let ref = Database.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: {snapshot in
            
            let users = snapshot.value as! [String: AnyObject]
            self.users.removeAll()
            
            for(_, value) in users{
                if let uid = value["uid"] as? String{
                    if uid != Auth.auth().currentUser?.uid{
                        let userToShow = User()
                        if let fullname = value["full name"] as? String, let imagePath = value["urlToImage"] as? String?{
                            userToShow.fullName = fullname
                            userToShow.imagePath = imagePath
                            userToShow.userID = uid
                            self.users.append(userToShow)
                            
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
            
        })
        
        ref.removeAllObservers()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        
        cell.nameLabel.text = self.users[indexPath.row].fullName
        cell.userID = self.users[indexPath.row].userID
        cell.userImage.downloadImage(from: self.users[indexPath.row].imagePath!)
        
        return cell
    }
    
    
}

extension UIImageView{
    func downloadImage(from imgURL: String!){
        let url = URLRequest(url: URL(string: imgURL)!)
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
