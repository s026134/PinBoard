//
//  PostScreenViewController.swift
//  PinBoard
//
//  Created by Claire Lu (student LM) on 2/23/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit

class PostScreenViewController: UIViewController {
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var postDatePicker: UIDatePicker!
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var Descrip: UITextView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
