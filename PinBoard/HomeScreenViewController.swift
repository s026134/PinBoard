//
//  HomeScreenViewController.swift
//  PinBoard
//
//  Created by Claire Lu (student LM) on 2/23/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    //UITableViewDataSource, UITableViewDelegate
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedDescription: UITextView!
    
    

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
