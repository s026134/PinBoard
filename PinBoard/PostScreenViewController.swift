//
//  PostScreenViewController.swift
//  PinBoard
//
//  Created by Claire Lu (student LM) on 2/23/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class PostScreenViewController: UIViewController {
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var postDatePicker: UIDatePicker!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var Descrip: UITextView!
    @IBOutlet weak var channel: UIPickerView!
    
    var rootRef : DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         rootRef = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addEventButton (_sender : UIButton){
        guard let uid = Auth.auth().currentUser?.uid else{return}

        let event = ["Title" : eventTitle.text!, "Date": postDatePicker.date.description, "Location" : location.text!, "Description" : Descrip.text!]
        
  
        rootRef.child("user/\(uid)/event/\(event["Title"])").setValue(event)
        
      
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ref = sender as? DatabaseReference{
            if let PostScreenViewController = segue.destination as? PostScreenViewController{
                PostScreenViewController.rootRef = ref
            }
        }
    }
    

}
