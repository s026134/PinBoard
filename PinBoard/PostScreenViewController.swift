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
    var channelsToSendTo = [String]()
    var tagz = [tags]()
    
    @IBOutlet weak var postView: UIView!
    let mintGreen = UIColor.init(red: 159/255, green: 216/255, blue: 138/255, alpha: 1)
    
    let blue = UIColor.init(red: 28/255, green: 53/255, blue: 130/255, alpha: 1)
    
    let coral = UIColor.init(red: 229/255, green: 88/255, blue: 93/255, alpha: 1)
    
    let lightBlue = UIColor.init(red: 170/255, green: 223/255, blue: 227/255, alpha: 1)
    
    @IBOutlet weak var selectChannelsButton: UIButton!
    @IBOutlet weak var selectChannelsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        eventTitle.layer.cornerRadius = eventTitle.frame.size.height/2
        eventTitle.layer.borderWidth = 2.0
        eventTitle.layer.borderColor = blue.cgColor
        eventTitle.layer.masksToBounds = true
        
        inputDate.layer.cornerRadius = eventTitle.frame.size.height/2
        inputDate.layer.borderWidth = 2.0
        inputDate.layer.borderColor = blue.cgColor
        inputDate.layer.masksToBounds = true
        
        location.layer.cornerRadius = eventTitle.frame.size.height/2
        location.layer.borderWidth = 2.0
        location.layer.borderColor = blue.cgColor
        location.layer.masksToBounds = true
        
        postButton.layer.masksToBounds = true
        postButton.layer.cornerRadius = postButton.frame.size.height/2
        
        selectChannelsButton.layer.cornerRadius = selectChannelsButton.frame.size.height/2
        selectChannelsButton.layer.borderWidth = 2.0
        selectChannelsButton.layer.borderColor = blue.cgColor
        selectChannelsButton.layer.masksToBounds = true
        
        
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
        
     
        selectChannelsLabel.text = " "
        removeValues()
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
                
                var xcoordinate = 50
                var ycoordinate = 870
                
                for i in chan{
                    self.channelsToSendTo.append(i)
                    
                    self.tagz.append(tags())
                    self.tagz.last?.channelLabel.text = i
                    
                    if i.count < 6 {
                        self.tagz.last?.tagView.frame = CGRect(x: xcoordinate - 20, y: ycoordinate - 2, width:
                            116, height: 35)
                        
                        self.tagz.last?.channelLabel.frame = CGRect(x: xcoordinate + 12, y : ycoordinate, width: 80, height: 30)
                    }
                    else{
                    self.tagz.last?.tagView.frame = CGRect(x: xcoordinate - 20, y: ycoordinate - 2, width:
                        118, height: 35)
                    
                    self.tagz.last?.channelLabel.frame = CGRect(x: xcoordinate, y : ycoordinate, width: 80, height: 30)
                    }
                    xcoordinate += 123
                    if xcoordinate > 310{
                        xcoordinate = 50
                        ycoordinate = 915
                    }
                    
                    self.postView.addSubview(self.tagz.last!.tagView)
                    self.postView.addSubview(self.tagz.last!.channelLabel)
                    
                    
//                    if i == chan.first{
//                        self.selectChannelsLabel.text = i
//                    }
//                    else if i != chan.last!{
//                    self.selectChannelsLabel.text = "\(self.selectChannelsLabel.text!)" + ", "
//                    }
//                    else{
//                        self.selectChannelsLabel.text = "\(self.selectChannelsLabel.text!)" + i
//                    }
//
                }
            }
            
        }
    }
    @IBAction func selectChannelsPressed(_ sender: UIButton) {
        removeValues()
        
        for i in tagz{
            i.tagView.removeFromSuperview()
            i.channelLabel.removeFromSuperview()
        }
        tagz.removeAll()
        print(tagz)
    }
    
    @IBAction func selectPressed(_ sender: UIButton) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    func removeValues() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users/\(uid!)/ChannelsToPostOn").removeValue()
    }
    
    @IBAction func postPressed(_ sender: UIButton) {
        LoadingScreen.instance.showLoader()
        
        let storage = Storage.storage().reference(forURL: "gs://pinboard-c2ef5.appspot.com")
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let key = ref.child("All Posts/\(uid!)/\(self.eventTitle.text!)")
        let imageRef = storage.child("\(key).jpg")
        
        guard let image = self.previewImage.image, let imageData = image.jpegData(compressionQuality: 0.6) else {return}
        
        let uploadTask = imageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
            
            if error != nil{
                print(error!.localizedDescription)
                LoadingScreen.instance.hideLoader()
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
                    self.performSegue(withIdentifier: "Nav", sender: self)
                    
                }
                
            })
            
            
        })
        
        uploadTask.resume()
        
        
    }
    
}

class tags: UIView {
    static let coral = UIColor.init(red: 229/255, green: 88/255, blue: 93/255, alpha: 1)
    static let blue = UIColor.init(red: 28/255, green: 53/255, blue: 130/255, alpha: 1)
    
    var tagView: UIView = {
        let tagView = UIView(frame: CGRect(x: 45, y: 900, width: 115, height: 35))
        tagView.backgroundColor = blue.withAlphaComponent(0.5)
        tagView.isUserInteractionEnabled = true
        tagView.layer.masksToBounds = true
        tagView.layer.cornerRadius = tagView.frame.height/2
        return tagView
    }()
    
    var channelLabel : UILabel = {
        let channelLabel = UILabel(frame: CGRect(x: 75, y: 902, width: 80, height: 30))
        channelLabel.textColor = .white
        channelLabel.font = UIFont(name: "Futura-Medium", size: 20)
        channelLabel.text = "Gaming"
        
        return channelLabel
    }()
    
}

