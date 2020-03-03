//
//  DashBoardEventsViewController.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 2/24/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class DashBoardEventsViewController: UIViewController {
//    UITableViewDelegate, UITableViewDataSource

    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var mainCell: UITableViewCell!
    
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var eventCell: UITableViewCell!
    
    var rootRef : DatabaseReference!
    var refEvent : DatabaseReference!
    var dataBaseHandle :DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refEvent = Database.database().reference().child("Events")
        
        //retrieving and listening for data from firebase database
        
       guard let uid = Auth.auth().currentUser?.uid else{return}
        refEvent.observe(.value, with: {(snap: DataSnapshot) in
            if let actualEvent = snap.value {
                if let date = actualEvent[]{
                    self.mainCell.textLabel?.text = date
                    self.mainTableView.reloadData()
                }
            }
            
            
            
        })
//            //take value from snapshot and add to table view and its cell
//            let event = snapshot.value as Any?
//
//            if let actualEvent = event {
//                if let date = actualEvent ["Date"] {
//                    self.mainCell.textLabel?.text = date
//
//                    self.mainTableView.reloadData()
//                }
//            }
           
           
            
            

        // Do any additional setup after loading the view.
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
