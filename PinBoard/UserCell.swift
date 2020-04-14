//
//  UserCell.swift
//  PinBoard
//
//  Created by Alexis Duong (student LM) on 4/13/20.
//  Copyright © 2020 Alexis Duong (student LM). All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profImage: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
