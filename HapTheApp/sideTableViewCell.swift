//
//  sideTableViewCell.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/8/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import UIKit

class sideTableViewCell: UITableViewCell {

    // Header Cell Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    // Typical Cell Outlets
    @IBOutlet weak var title: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
