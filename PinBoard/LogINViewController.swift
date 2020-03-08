//
//  LogINViewController.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 3/7/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth

class LogINViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        guard let email = email.text else {return}
        guard let password = password.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            
            if let _ = user{
                self.dismiss(animated: false, completion: nil)
            }
            else{
                print(error!.localizedDescription)
            }
        
        })
        
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
