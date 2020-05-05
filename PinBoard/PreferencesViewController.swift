//
//  PreferencesViewController.swift
//  PinBoard
//
//  Created by Justin Minerva (student LM) on 2/21/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class PreferencesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var prefCV: UICollectionView!
    let darkBlue = UIColor.init(red: 0/255, green: 0/255, blue: 51/255, alpha: 1)
    let grayBlue = UIColor.init(red: 204/255, green: 218/255, blue: 233/255, alpha: 1)
    var collectionData = ["gaming1", "music1", "math1", "sci1", "sports1", "reading1", "comp1", "tv1", "food1", "mis1"]
    var collectionData2 = ["Gaming", "Music", "Math", "Science", "Sports", "Reading", "CS", "TV", "Food", "MISC"]
    let layoutCV = UICollectionViewFlowLayout()
  //  var userTags: Set<Int> = []
    var subscribed: [Int] = []
    var followersArr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCV.itemSize = CGSize(width: 200, height: 250)
        prefCV.collectionViewLayout = layoutCV
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUpButtonTouchedUp(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let storage = Storage.storage().reference(forURL: "gs://pinboard-c2ef5.appspot.com")
        
        for i in 0...subscribed.count-1 {
            let elementNum = subscribed[i]
            followersArr.append(collectionData[elementNum])
        }
       // ref.child("users/\(uid!)").setValue([followersArr])
        
        ref.child("users/\(uid!)/").updateChildValues(["following": followersArr])
        
   //     print(followersArr)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)->UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.label.text = collectionData2[indexPath.item]
        let imageName =  collectionData[indexPath.item]
        let theImage = UIImage(named: imageName)
        cell.image.image = theImage
        
        cell.layer.cornerRadius = 5
        
        if subscribed.contains(indexPath.item) {
            cell.label.textColor = grayBlue
            cell.backgroundColor = darkBlue
        }
        else {
            cell.label.textColor = darkBlue
            cell.backgroundColor = grayBlue
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let cell3 = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
      
        if subscribed.contains(indexPath.item) {
            print(indexPath.item)
            
            cell3.label.textColor = grayBlue
            cell3.backgroundColor = darkBlue
            
            let number = indexPath.item
            var index: Int
            for i in 0 ..< subscribed.count {
                if number == subscribed[i] {
                    index = i
                    subscribed.remove(at: index)
                    cell3.label.textColor = darkBlue
                    cell3.backgroundColor = grayBlue
                }
            }
            
          
        }
        else {
            subscribed.append(indexPath.item)
            cell3.backgroundColor = darkBlue
           
            cell3.label.textColor = grayBlue
            
        }
        print(subscribed)
       
    }
    
}
