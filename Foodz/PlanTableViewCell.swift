//
//  PlanTableViewCell.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 06/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import UIKit

class PlanTableViewCell: UITableViewCell {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
