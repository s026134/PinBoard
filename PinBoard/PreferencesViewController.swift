//
//  PreferencesViewController.swift
//  PinBoard
//
//  Created by Justin Minerva (student LM) on 2/21/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth

class PreferencesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionData = ["🎮 Gaming", "🎶 Music", "➕Math", "🔬 Science", "🥏 Sports ", "📚 Reading", "💻 Computer Science", " 📺 TV", "🌮 Food", "🤪 Misc"]
    
    var userTags: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)->UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.label.text = collectionData[indexPath.item]
        cell.layer.cornerRadius = 35
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        if let index = userTags.firstIndex(of: indexPath.item){
            userTags.remove(at: index)
            cell?.contentView.backgroundColor = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
        }
        else{
            userTags.insert(indexPath.item)
        }
        print(userTags)
    }
    
}
