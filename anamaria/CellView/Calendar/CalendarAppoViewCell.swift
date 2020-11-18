//
//  CalendarAppoViewCell.swift
//  anamaria
//
//  Created by ArturoGR on 9/8/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit

class CalendarAppoViewCell: UITableViewCell {

    @IBOutlet weak var isTutor: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var onButtonTapped : (() -> Void)? = nil
    @IBAction func click(_ sender: Any) {
        
        if let onButtonTapped = self.onButtonTapped{
            onButtonTapped()
        }
        
    }
    
    
}
