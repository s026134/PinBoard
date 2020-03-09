//
//  SignUpViewController.swift
//  PinBoard
//
//  Created by Justin Minerva (student LM) on 2/21/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddress.delegate = self
        password.delegate = self
        picker.delegate = self
        emailAddress.becomeFirstResponder()
        
        let storage = Storage.storage().reference(forURL: "gs://pinboard-c2ef5.appspot.com")
        ref = Database.database().reference()
//        userStorage = Storage.storage().child("users")
        userStorage = storage.child("users")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailAddress.isFirstResponder {
            password.becomeFirstResponder()
        }
        else{
            password.resignFirstResponder()
            signUpButton.isEnabled = true
        }
        
        return true
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.imageView.image = image
            signUpButton.isHidden = false
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func selectImagePressed(_ sender: UIButton) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func signUpButtonTouchedUp(_ sender: UIButton) {
        guard let email = emailAddress.text else {return}
        guard let password = password.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let _ = user{
                print("user created")
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = email
                changeRequest?.commitChanges(completion: { (error) in
                    print ("couldn't change name")
                })
                
                guard let uid = Auth.auth().currentUser?.uid else{return}
                
                let imageRef = self.userStorage.child("\(uid).jpg")
                
                
                //            let data = UIImage.jpegData(self.imageView.image!, 0.5)
                guard let image = self.imageView?.image, let imageData = image.jpegData(compressionQuality: 0.75) else {return}
                
                
                let uploadTask = imageRef.putData(imageData, metadata: nil, completion: {(metadata, err) in
                    
                    if err != nil{
                        print(err!.localizedDescription)
                    }
                    
                    imageRef.downloadURL(completion: {(url, er) in
                        
                        if er != nil{
                            print(er!.localizedDescription)
                        }
                        
                        if let url = url{
                            let userInfo: [String : Any] = ["uid" : uid, "full name" : self.nameTextField.text!, "urlToImage" : url.absoluteString]
                            
                            self.ref.child("users").child(uid).setValue(userInfo)
                            
//                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "usersPrefVC")
//                            
//                            self.present(vc, animated: true, completion: nil)
                            
                        }
                        
                        
                    })
                    
                    
                })
                
                uploadTask.resume()
                
                
                
                self.dismiss(animated: true, completion: nil)
                
                
            }
                
            else{
                print(error.debugDescription)
            }
            
            
        }
    }
    
    
}
