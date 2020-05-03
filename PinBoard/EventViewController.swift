//
//  EventViewController.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 4/6/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EventViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var descrip: UITextView!
    @IBOutlet weak var attendLabel: UILabel!
    @IBOutlet weak var imAge: UIImageView!
    var eventTitle : String!
    var eventDate : String!
    var loc : String!
    var Descrip : String!
    var attending : String!
    var imageURL: String!
    var fromDashboard: String?
    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    
    @IBOutlet weak var viewOpac: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingScreen.instance.showLoader()
        
        let blue = UIColor.init(red: 28/255, green: 53/255, blue: 130/255, alpha: 0.2)
        viewOpac.backgroundColor = blue
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        if fromDashboard != nil{
            ref.child("All Posts/\(uid!)/\(fromDashboard!)").observe(.value){(snapshot) in
                let elements = snapshot.value as? [String: Any]
                if let element = elements{
                    for (ele, val) in element{
                        if ele == "attending"{
                            self.attendLabel.text = "\(val as! Int)"
                        }
                        else if ele == "description"{
                            self.descrip.text = val as? String
                        }
                        else if ele == "eventDate"{
                            self.dateLabel.text = val as? String
                        }
                        else if ele == "eventTitle"{
                            self.titleLabel.text = val as? String
                        }
                        else if ele == "location"{
                            self.location.text = val as? String
                        }
                        else if ele == "pathToImage"{
                            self.imAge.downloadImage(from: val as? String)
                        }
                    }
                }
            }
        }
        
        else{
            titleLabel.text = eventTitle
            dateLabel.text = eventDate
            location.text = loc
            descrip.text = Descrip
            attendLabel.text = attending
            imAge.downloadImage(from: imageURL)
        }
        
        LoadingScreen.instance.hideLoader()
        
    }
    
    @IBAction func attendingPressed(_ sender: UIButton) {
        let key = ref.child("All Posts/\(uid!)/\(titleLabel.text!)/attending")
        
        key.observeSingleEvent(of: .value){(snapshot) in
            
            let attend = snapshot.value as? Int
            if let att = attend{
                self.attendLabel.text = "\(att + 1)"
                key.setValue(att + 1)
            }
            else{
                self.attendLabel.text = "1"
                key.setValue(1)
            }

        }
        
    }
    
}

