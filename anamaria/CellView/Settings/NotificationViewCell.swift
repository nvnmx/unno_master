//
//  NotificationViewCell.swift
//  anamaria
//
//  Created by ArturoGR on 8/18/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit

class NotificationViewCell: UITableViewCell {
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var onButtonTapped : (() -> Void)? = nil
    
    @IBAction func btnIr(_ sender: Any) {
        if let onButtonTapped = self.onButtonTapped{
                   onButtonTapped()
               }
    }
}
