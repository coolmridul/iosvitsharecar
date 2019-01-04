//
//  ViewControllerTableViewCell.swift
//  VIT ShareCar
//
//  Created by Mridul Agarwal on 21/12/18.
//  Copyright © 2018 Techifuzz. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var nametext: UILabel!
    @IBOutlet weak var fromtext: UILabel!
    @IBOutlet weak var totext: UILabel!
    @IBOutlet weak var datetext: UILabel!
    @IBOutlet weak var timetext: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
