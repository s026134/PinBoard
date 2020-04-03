//
//  PostCell.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 3/23/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PostCell: UICollectionViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var userPostedLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriPLabel: UILabel!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var attendingLabel: UILabel!
    
    @IBAction func attendPressed(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let key = ref.child("All Posts/\(uid)/\(eventTitleLabel.text)/attending")
        
        if let attend = attendingLabel.text{
            key.setValue(Int(attend)! + 1)
        }
        
        
    }

}
