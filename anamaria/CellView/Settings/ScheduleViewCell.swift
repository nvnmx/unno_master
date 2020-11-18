//
//  ScheduleViewCell.swift
//  anamaria
//
//  Created by ArturoGR on 8/19/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit

class ScheduleViewCell: UICollectionViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var lblHorario: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var onButtonTapped : (() -> Void)? = nil
    @IBAction func click(_ sender: Any) {
        
        if let onButtonTapped = self.onButtonTapped{
            onButtonTapped()
        }
        
    }
    
}
