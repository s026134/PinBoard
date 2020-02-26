//
//  LogInViewController.swift
//  PinBoard
//
//  Created by Claire Lu (student LM) on 2/26/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBAction func loginButton(_ sender: UIButton) {
        print("hello")
    }
    
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
