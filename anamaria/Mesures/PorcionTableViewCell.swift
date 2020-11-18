//
//  PorcionTableViewCell.swift
//  unno
//
//  Created by Bet Data Analysis on 28/09/20.
//  Copyright © 2020 nvn. All rights reserved.
//

import UIKit




class PorcionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAlimento: UILabel!
    
    @IBOutlet weak var lblTazas: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
