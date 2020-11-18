//
//  CalendarViewCell.swift
//  unno
//
//  Created by Bet Data Analysis on 20/07/20.
//  Copyright © 2020 nvn. All rights reserved.
//

import UIKit

class CalendarViewCell: UITableViewCell {

    @IBOutlet weak var lblHorario: UILabel!
    @IBOutlet weak var lblDias: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
