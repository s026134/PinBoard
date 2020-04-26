//
//  PostScreenViewController.swift
//  PinBoard
//
//  Created by Claire Lu (student LM) on 2/23/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
//I still need to do the selecting channels stuff but otherwise this is good

class PostScreenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var inputDate: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var Descrip: UITextView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var selectImage: UIButton!
    
    var picker = UIImagePickerController()
    var datePicker : UIDatePicker?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    var channelsToSendTo = [String]()
    
    @IBOutlet weak var selectChannelsButton: UIButton!
    @IBOutlet weak var selectChannelsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(PostScreenViewController.dateChanged(datePicker: )), for: .valueChanged)
        inputDate.inputView = datePicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostScreenViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        picker.delegate = self
        
        //post button appears doesn't work need to fix it
        if Descrip.text == ""{
            postButton.isHidden = false
        }
        
        
        activityIndicator.hidesWhenStopped = true
        selectChannelsLabel.text = " "
        retreiveSelectedChannels()
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        inputDate.text = dateFormatter.string(from: datePicker.date)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.previewImage.image = image
            selectImage.isHidden = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func retreiveSelectedChannels() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users/\(uid!)/ChannelsToPostOn").observe(.value){(snapshot) in
            
            let channels = snapshot.value as? [String]
            
            if let chan = channels{
                self.selectChannelsLabel.isHidden = false
                
                for i in chan{
                    self.channelsToSendTo.append(i)
                    if i == chan.first{
                        self.selectChannelsLabel.text = i
                    }
                    else if i != chan.last!{
                    self.selectChannelsLabel.text = "\(self.selectChannelsLabel.text!)" + ", "
                    }
                    else{
                        self.selectChannelsLabel.text = "\(self.selectChannelsLabel.text!)" + i
                    }
                    
                }
            }
            
        }
    }
    
    @IBAction func selectPressed(_ sender: UIButton) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func postPressed(_ sender: UIButton) {
//        activityIndicator.startAnimating()
        LoadingScreen.instance.showLoader()
        loadingLabel.isHidden = false
        
        let storage = Storage.storage().reference(forURL: "gs://pinboard-c2ef5.appspot.com")
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let key = ref.child("All Posts/\(uid!)/\(self.eventTitle.text!)")
        let imageRef = storage.child("\(key).jpg")
        
        guard let image = self.previewImage.image, let imageData = image.jpegData(compressionQuality: 0.6) else {return}
        
        let uploadTask = imageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
            
            if error != nil{
                print(error!.localizedDescription)
                self.activityIndicator.stopAnimating()
                self.loadingLabel.isHidden = true
                return
            }
            
            imageRef.downloadURL(completion: {(url, error) in
                if let url = url {
                    let feed = ["userID" : uid!, "pathToImage" : url.absoluteString, "attending" : 0, "userName" : Auth.auth().currentUser?.email!, "eventTitle" : self.eventTitle.text!, "eventDate" : self.inputDate.text!, "location" : self.location.text!, "description": self.Descrip.text!] as [String : Any]
                    
                    
                    
                    // need to change display name from email to an actual username
                    
                    let postFeed = ["\(self.eventTitle.text!)" : feed]
                    ref.child("All Posts/\(uid!)/\(self.eventTitle.text!)").setValue(feed)
                    for i in self.channelsToSendTo{
                        ref.child("All Posts/\(i)/\(self.eventTitle.text!)").setValue(feed)
                    }
                    
                    ref.child("users/\(uid!)/ChannelsToPostOn").removeValue()
                    
                    LoadingScreen.instance.hideLoader()
//                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "Nav", sender: self)
                    
                }
                
            })
            
            
        })
        
        uploadTask.resume()
        
        
    }
    
    
}
