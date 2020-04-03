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

class DashBoardEventsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var weeklySidebar: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    var month : String = ""
    var day : String = ""
    var weeklylabels = [weeklyLabels]()
    var events: [String] = []
   
    @IBOutlet weak var eventTableView: UITableView!
    
    let mintGreen = UIColor.init(red: 159/255, green: 216/255, blue: 138/255, alpha: 1)
    
    let blue = UIColor.init(red: 28/255, green: 53/255, blue: 130/255, alpha: 1)
    
    let coral = UIColor.init(red: 229/255, green: 88/255, blue: 93/255, alpha: 1)
    
    let lightBlue = UIColor.init(red: 170/255, green: 223/255, blue: 227/255, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weeklySidebar.delegate = self
        weeklySidebar.dataSource = self
        weeklySidebar.collectionViewLayout = layout
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
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
        label1.dayLabell = "\(Int(dayString)!)"
        label1.monthLabell = month
        weeklylabels.append(label1)
        
        for i in (Int(dayString)! + 1) ... daysInMonth[month]!{
            let label2 = weeklyLabels()
            label2.addLabels(dayLabell: "\(i)", monthLabell: month)
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
       
        //side bar cell for day and month
            let cell = weeklySidebar.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! dayCell
            
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .white
            cell.dayLabel.text = weeklylabels[indexPath.row].dayLabell
            cell.monthLabel.text = weeklylabels[indexPath.row].monthLabell
            return cell
     
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
            let cell = weeklySidebar.cellForItem(at: indexPath) as! dayCell
            
            cell.backgroundColor = blue
            cell.dayLabel.textColor = coral
            cell.monthLabel.textColor = coral
            
        eventTableView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            let cell = weeklySidebar.cellForItem(at: indexPath) as! dayCell
            
            cell.backgroundColor = .white
            cell.dayLabel.textColor = blue
            cell.monthLabel.textColor = blue

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! eventCell
        
        cell.backgroundColor = lightBlue
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 3
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            //delete stuff
            events.remove(at: indexPath.row)
            eventTableView.reloadData()
        }
    }
    
}


class weeklyLabels : UIViewController{
    var dayLabell : String = ""
    var monthLabell : String = ""
    
    func addLabels (dayLabell: String, monthLabell: String){
        self.dayLabell = dayLabell
        self.monthLabell = monthLabell
        
    }
}


