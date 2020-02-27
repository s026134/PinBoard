//
//  SignUpViewController.swift
//  PinBoard
//
//  Created by Justin Minerva (student LM) on 2/21/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddress.delegate = self
        password.delegate = self
        emailAddress.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailAddress.isFirstResponder {
            password.becomeFirstResponder()
        }
        else{
            passwordTextField.resignFirstResponder()
            signUpButton.isEnabled = true
        }
        
        return true
    }
    
    @IBAction func signUpButtonTouchedUp(_ sender: UIButton) {
        guard let email = emailAddress.text else {return}
        guard let password = password.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let _ = user{
                print("user created")
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = userName
                changeRequest?.commitChanges(completion: { (error) in
                    print ("couldn't change name")
                })
                self.dismiss(animated: true, completion: nil)
            }
            else{
                print(error.debugDescription)
            }
        }
    }
    

}
