//
//  ViewController.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 2/19/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let _ = Auth.auth().currentUser{
//            self.performSegue(withIdentifier: "HomeScreenViewController", sender: self)
//        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = Auth.auth().currentUser{
            self.performSegue(withIdentifier: "toTheNav", sender: self)
        }
    }
    
}

