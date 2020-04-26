//
//  LogINViewController.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 3/7/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth

class LogINViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var invalidLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        email.becomeFirstResponder()
        
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if email.isFirstResponder{
            password.becomeFirstResponder()
        }
            
        else{
            password.resignFirstResponder()
            logInButton.isEnabled = true
        }
        
        return true
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
//        activityIndicator.startAnimating()
        LoadingScreen.instance.showLoader()
        var emOrpas = ""
        
        guard let email = email.text else {return}
        guard let password = password.text else {return}

        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
//            self.activityIndicator.stopAnimating()
            LoadingScreen.instance.hideLoader()
            if let _ = user{
                self.performSegue(withIdentifier: "toNav", sender: self)
                self.invalidLabel.isHidden = false
                self.invalidLabel.textColor = .white
                self.invalidLabel.text = "Successful!"
            }
                
            else{
                 print("true")
                //checks to see which was incorrect
                if email != user?.user.email{
                    emOrpas = "email"
                }
                
                else{
                    emOrpas = "password"
                }
            
                self.invalidLabel.isHidden = false
                self.invalidLabel.text = "Invalid \(emOrpas)"
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
