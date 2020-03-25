//
//  DashBoardEventsViewController.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 2/24/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class DashBoardEventsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    //    UITableViewDelegate, UITableViewDataSource
    
    @IBOutlet weak var weeklySidebar: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    var month : String = ""
    var day : String = ""
    var weeklylabels = [weeklyLabels]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weeklySidebar.delegate = self
        weeklySidebar.dataSource = self
        weeklySidebar.collectionViewLayout = layout
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
      
        let currentDateTime = Date()
        let monthFormatter = DateFormatter()
        let dayFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        dayFormatter.dateFormat = "dd"
        
        let monthString = monthFormatter.string(from: currentDateTime)
        
        let dayString = dayFormatter.string(from: currentDateTime)
            
        let monthsNumber = [1 : "JAN", 2 : "FEB", 3 : "MAR", 4 : "APR", 5 : "MAY", 6 : "JUN", 7 : "JUL", 8 : "AUG", 9 : "SEP", 10: "OCT", 11 : "NOV", 12 : "DEC"]
        
        let daysInMonth = ["JAN" : 31, "FEB" : 28, "MAR" : 31, "APR" : 30, "MAY" : 31, "JUN" : 30, "JUL" : 31, "AUG" : 31, "SEP" : 30, "OCT" : 31, "NOV" : 30, "DEC" : 31]
       
        month = "\(monthsNumber[Int(monthString)!]!)"
        
        let label1 = weeklyLabels()
        label1.dayLabell = dayString
        label1.monthLabell = month
        weeklylabels.append(label1)
        
        for i in (Int(dayString)! + 1) ... daysInMonth[month]!{
            let label2 = weeklyLabels()
            label2.addLabels(dayLabell: "\(i)", monthLabell: month)
//            label.dayLabell = "\(i)"
//            label.monthLabell = month
            weeklylabels.append(label2)
        }
        var nextmonth = (Int(monthString)! + 1)
        
        //once we reach december
        if nextmonth == 13{
            nextmonth = 1
        }
        
        for i in 1 ... daysInMonth[monthsNumber[nextmonth]!]! {
            let label3 = weeklyLabels()
            label3.addLabels(dayLabell: "\(i)", monthLabell: monthsNumber[(Int(monthString)! + 1)]!)
             weeklylabels.append(label3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weeklySidebar.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! dayCell
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .white
        cell.dayLabel.text = weeklylabels[indexPath.row].dayLabell
        cell.monthLabel.text = weeklylabels[indexPath.row].monthLabell
    
        return cell
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

class weeklyLabels : UIViewController{
    var dayLabell : String = ""
    var monthLabell : String = ""
    
    func addLabels (dayLabell: String, monthLabell: String){
        self.dayLabell = dayLabell
        self.monthLabell = monthLabell

    }
}
