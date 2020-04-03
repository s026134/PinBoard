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
    
    let darkBlue = UIColor.init(red: 0/255, green: 0/255, blue: 51/255, alpha: 1)
    let grayBlue = UIColor.init(red: 204/255, green: 218/255, blue: 233/255, alpha: 1)
    var collectionData = ["🎮 Gaming", "🎶 Music", "➕Math", "🔬 Science", "🥏 Sports ", "📚 Reading", "💻 Computer Science", " 📺 TV", "🌮 Food", "🤪 Misc"]
    
  //  var userTags: Set<Int> = []
    var subscribed: [Int] = []
    var followersArr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.label.text = collectionData[indexPath.item]
        cell.layer.cornerRadius = 35
        cell.backgroundColor = grayBlue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let cell3 = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        cell3.backgroundColor = grayBlue
        
        
        
        if subscribed.contains(indexPath.item) {
            let index = subscribed.firstIndex { (Int) -> Bool in
                if Int == indexPath.item {
                    return true
                }
                else {
                    return false
                }
            }
          //  print(index)
            if let num = index {
                subscribed.remove(at: num)
                cell3.label.textColor = darkBlue
            }
        }
        else {
            subscribed.append(indexPath.item)
            cell3.backgroundColor = darkBlue
           
            cell3.label.textColor = grayBlue
            
        }
        print(subscribed)
        /*
         I commented this out, wasn't sure what it did - claire
        if let index = userTags.firstIndex(of: indexPath.item){
            userTags.remove(at: index)
            cell?.contentView.backgroundColor = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
        }
        else{
            userTags.insert(indexPath.item)
        }
        print(userTags)
    */
    }
    
}
