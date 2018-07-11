//
//  PizzaPlaceTableViewCell.swift
//  Pizza Restaurants
//
//  Created by Admin on 11/07/2018.
//  Copyright © 2018 Gary Luk. All rights reserved.
//

import UIKit

class PizzaPlaceTableViewCell: UITableViewCell {

    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var address1Label: UILabel!
    @IBOutlet var address2Label: UILabel!
    @IBOutlet var address3Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
