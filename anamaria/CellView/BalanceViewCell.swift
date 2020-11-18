//
//  BalanceViewCell.swift
//  anamaria
//
//  Created by ArturoGR on 9/6/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit

class BalanceViewCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblConcept: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
