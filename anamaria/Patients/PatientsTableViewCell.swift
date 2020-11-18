//
//  PatientsTableViewCell.swift
//  anamaria
//
//  Created by Francisco on 12/17/18.
//  Copyright © 2018 nvn. All rights reserved.
//

import UIKit

class PatientsTableViewCell: UITableViewCell {

    @IBOutlet weak var isTutor: UIImageView!
    @IBOutlet weak var name: UILabel!
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
