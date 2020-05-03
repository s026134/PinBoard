//
//  popUpEventCell.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 5/3/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit

class popUpEventCell: UITableViewCell {

    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
