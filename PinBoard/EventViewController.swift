//
//  EventViewController.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 4/6/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    var eventzCell : PostCell!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var descrip: UILabel!
    @IBOutlet weak var attendLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = eventzCell.eventTitleLabel.text
        dateLabel.text = eventzCell.dateLabel.text
        location.text = eventzCell.locLabel.text
        descrip.text = eventzCell.descriPLabel.text
        attendLabel.text = eventzCell.attendingLabel.text
       
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
