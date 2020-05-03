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
    var events = [Post]()
    
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var popUpTableView: UITableView!
    @IBOutlet weak var popUpButton: UIButton!
    @IBOutlet weak var popUpLabel: UILabel!
    let mintGreen = UIColor.init(red: 159/255, green: 216/255, blue: 138/255, alpha: 1)
    
    let blue = UIColor.init(red: 28/255, green: 53/255, blue: 130/255, alpha: 1)
    
    let coral = UIColor.init(red: 229/255, green: 88/255, blue: 93/255, alpha: 1)
    
    let lightBlue = UIColor.init(red: 170/255, green: 223/255, blue: 227/255, alpha: 1)
    
    var selectedDay = ""
    var selectedMonth = ""
    let monthsNumber = [1 : "JAN", 2 : "FEB", 3 : "MAR", 4 : "APR", 5 : "MAY", 6 : "JUN", 7 : "JUL", 8 : "AUG", 9 : "SEP", 10: "OCT", 11 : "NOV", 12 : "DEC"]
    
    let daysInMonth = ["JAN" : 31, "FEB" : 28, "MAR" : 31, "APR" : 30, "MAY" : 31, "JUN" : 30, "JUL" : 31, "AUG" : 31, "SEP" : 30, "OCT" : 31, "NOV" : 30, "DEC" : 31]
    
    let currentDateTime = Date()
    let monthFormatter = DateFormatter()
    let dayFormatter = DateFormatter()
    var selectedEvent  = ""
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    var sortedFutureEventDates = [Post]()
    var sortedPastEventDates = [Post]()
    //false is past, true is future
    var pasFut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingScreen.instance.showLoader()
        weeklySidebar.delegate = self
        weeklySidebar.dataSource = self
        weeklySidebar.collectionViewLayout = layout
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        popUpTableView.delegate = self
        popUpTableView.dataSource = self
        
        popUpView.layer.cornerRadius = 20
        popUpTableView.backgroundColor = blue
        
        monthFormatter.dateFormat = "MM"
        dayFormatter.dateFormat = "dd"
        
        let monthString = monthFormatter.string(from: currentDateTime)
        
        var dayString = dayFormatter.string(from: currentDateTime)
        
        month = "\(monthsNumber[Int(monthString)!]!)"
        
        let label1 = weeklyLabels()
        label1.dayLabell = "\(Int(dayString)!)"
        label1.monthLabell = month
        weeklylabels.append(label1)
        
        //when you reach the end of the month
        if (Int(dayString)! + 1) > daysInMonth[month]!{
            dayString = "0"
            month = "\(monthsNumber[Int(monthString)! + 1]!)"
        }
        
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
        
        fetchPosts()
    }
    
    
    func fetchPosts(){
        
        ref.child("All Posts/\(uid!)").observe(.value){(snapshot) in
            var posty : Post?
            let allPosts = snapshot.value as? [String: AnyObject]
            if let allThePosts = allPosts{
                for(postName, post) in allThePosts{
                    for i in self.events{
                        if i.eventTitle as! String == postName as! String{
                            posty = i
                        }
                    }
                    if posty != nil{
                        if let pos = posty{
                            for (category, element) in post as! [String: AnyObject]{
                                if category == "pathToImage" {
                                    pos.pathToimage = element
                                }
                                else if category == "eventDate"{
                                    pos.eventDate = element
                                }
                                else if category == "attending"{
                                    pos.attending = element
                                }
                                else if category == "description"{
                                    pos.Descrip = element
                                }
                                else if category == "eventTitle"{
                                    pos.eventTitle = element
                                }
                                else if category == "userID"{
                                    pos.userID = element
                                }
                                else if category == "location"{
                                    pos.location = element
                                }
                                else if category == "userName"{
                                    pos.userName = element
                                }
                            }
                        }
                    }
                        
                    else{
                        self.events.append(Post())
                        if let pos = self.events.last{
                            for (category, element) in post as! [String: AnyObject]{
                                if category == "pathToImage" {
                                    pos.pathToimage = element
                                }
                                else if category == "eventDate"{
                                    pos.eventDate = element
                                }
                                else if category == "attending"{
                                    pos.attending = element
                                }
                                else if category == "description"{
                                    pos.Descrip = element
                                }
                                else if category == "eventTitle"{
                                    pos.eventTitle = element
                                }
                                else if category == "userID"{
                                    pos.userID = element
                                }
                                else if category == "location"{
                                    pos.location = element
                                }
                                else if category == "userName"{
                                    pos.userName = element
                                }
                            }
                        }
                    }
                    
                }
                
            }
            
            self.eventTableView.reloadData()
            self.weeklySidebar.reloadData()
        }
    }
    
    @IBAction func pastEventsPressed(_ sender: UIButton) {
        popUpView.isHidden = false
        popUpLabel.text = "Past Events"
        pasFut = false
        popUpView.isUserInteractionEnabled = true
        popUpTableView.reloadData()
    }
    @IBAction func futureEventsPressed(_ sender: UIButton) {
        popUpView.isHidden = false
        pasFut = true
        popUpLabel.text = "Future Events"
        popUpView.isUserInteractionEnabled = true
        popUpTableView.reloadData()
    }
    
    @IBAction func popUpButtonxPressed(_ sender: UIButton) {
        popUpView.isHidden = true
        popUpView.isUserInteractionEnabled = false
        sortedPastEventDates.removeAll()
        sortedFutureEventDates.removeAll()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 14
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //side bar cell for day and month
        let cell = weeklySidebar.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! dayCell
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 0.2)
        cell.dayLabel.text = weeklylabels[indexPath.row].dayLabell
        cell.monthLabel.text = weeklylabels[indexPath.row].monthLabell
        
        for i in events{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            let date = dateFormatter.date(from: i.eventDate as! String)
            
            
            if let dat = date{
                if cell.dayLabel.text == "\(Int(dayFormatter.string(from: dat))!)" && cell.monthLabel.text == "\(monthsNumber[Int(monthFormatter.string(from: dat))!]!)"{
                    cell.eventIndicator.isHidden = false
                }
            }
        }
        
        LoadingScreen.instance.hideLoader()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = weeklySidebar.cellForItem(at: indexPath) as! dayCell
        
        cell.backgroundColor = blue.withAlphaComponent(1.0)
        cell.dayLabel.textColor = .white
        cell.monthLabel.textColor = .white
        
        if let day = cell.dayLabel.text{
            selectedDay = day
        }
        if let month = cell.monthLabel.text{
            selectedMonth = month
        }
        eventTableView.reloadData()
        
        eventTableView.isHidden = false
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = weeklySidebar.cellForItem(at: indexPath) as! dayCell
        
        cell.backgroundColor = .white
        cell.dayLabel.textColor = blue
        cell.monthLabel.textColor = blue
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == eventTableView{
            var count = 0
            if self.events.count > 0 {
                for i in 0...(events.count-1){
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                    let date = dateFormatter.date(from: events[i].eventDate as! String)
                    
                    
                    if let dat = date{
                        if selectedDay == "\(Int(dayFormatter.string(from: dat))!)" && selectedMonth == "\(monthsNumber[Int(monthFormatter.string(from: dat))!]!)"{
                            count += 1
                        }
                    }
                }
            }
            return count
        }
            
        else{
            if self.events.count > 0 {
                
                //sorting dates
                for i in 0...(events.count-1){
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                    let monthFormatter = DateFormatter()
                    monthFormatter.dateFormat = "MM"
                    let dayFormatter = DateFormatter()
                    dayFormatter.dateFormat = "dd"
                    let yearFormatter = DateFormatter()
                    yearFormatter.dateFormat = "yyyy"
                    
                    
                    if Int(yearFormatter.string(from: currentDateTime))! < Int(yearFormatter.string(from: dateFormatter.date(from: events[i].eventDate as! String)!))!{
                        sortedFutureEventDates.append(events[i])
                    }
                    else if Int(yearFormatter.string(from: currentDateTime))! > Int(yearFormatter.string(from: dateFormatter.date(from: events[i].eventDate as! String)!))!{
                        sortedPastEventDates.append(events[i])
                    }
                    else{
                        if Int(monthFormatter.string(from: currentDateTime))! < Int(monthFormatter.string(from: dateFormatter.date(from: events[i].eventDate as! String)!))!{
                            sortedFutureEventDates.append(events[i])
                        }
                        else if Int(monthFormatter.string(from: currentDateTime))! > Int(monthFormatter.string(from: dateFormatter.date(from: events[i].eventDate as! String)!))!{
                            sortedPastEventDates.append(events[i])
                        }
                        else{
                            if Int(dayFormatter.string(from: currentDateTime))! < Int(dayFormatter.string(from: dateFormatter.date(from: events[i].eventDate as! String)!))!{
                                sortedFutureEventDates.append(events[i])
                            }
                            else if Int(dayFormatter.string(from: currentDateTime))! > Int(dayFormatter.string(from: dateFormatter.date(from: events[i].eventDate as! String)!))!{
                                sortedPastEventDates.append(events[i])
                            }
                        }
                    }
                    
                    
                    
                }
                if pasFut == true{
                    return sortedFutureEventDates.count
                }
                else{
                    return sortedPastEventDates.count
                }
            }
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == eventTableView{
            let cell = eventTableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! eventCell
            
            cell.backgroundColor = .white
            cell.layer.borderColor = coral.cgColor
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 2
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            for i in 0...(events.count-1){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                let date = dateFormatter.date(from: events[i].eventDate as! String)
                
                if let dat = date{
                    
                    if selectedDay == "\(Int(dayFormatter.string(from: dat))!)"{
                        cell.eventTitleLabel.text = events[i].eventTitle as? String
                        cell.timeLabel.text = timeFormatter.string(from: dat)
                        cell.locationLabel.text = events[i].location as? String
                    }
                    
                }
            }
            
            return cell
        }
            
        else{
            let cell = popUpTableView.dequeueReusableCell(withIdentifier: "popUpEventCell", for: indexPath) as! popUpEventCell
            
            if pasFut == true{
                cell.eventTitleLabel.text = sortedFutureEventDates[indexPath.row].eventTitle as? String
                cell.dateTimeLabel.text = sortedFutureEventDates[indexPath.row].eventDate as? String
            }
            else{
                cell.eventTitleLabel.text = sortedPastEventDates[indexPath.row].eventTitle as? String
                cell.dateTimeLabel.text = sortedPastEventDates[indexPath.row].eventDate as? String
            }
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            //delete stuff
            ref.child("All Posts/\(uid)/\(events.remove(at: indexPath.row).eventTitle as? String)").removeValue()
            eventTableView.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == eventTableView{
            let cell = eventTableView.cellForRow(at: indexPath) as! eventCell
            selectedEvent = cell.eventTitleLabel.text!
            
        }
            
        else{
            let cell = popUpTableView.cellForRow(at: indexPath) as! popUpEventCell
            selectedEvent = cell.eventTitleLabel.text!
            
        }
        self.performSegue(withIdentifier: "moreDeat", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? EventViewController{
            nextViewController.fromDashboard = selectedEvent
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




