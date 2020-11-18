//
//  CitaViewCell.swift
//  anamaria
//
//  Created by ArturoGR on 9/8/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit

class CitaViewCell: UITableViewCell {

    @IBOutlet weak var reloj: UIImageView!
    @IBOutlet weak var lblNoHay: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMore: UIView!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var delete: UIView!
    @IBOutlet weak var reShedule: UIView!
    @IBOutlet weak var containerCell: UIView!
    
    @IBOutlet weak var viewBtnNuevo: UIView!
    
    
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
 
    var onButtonDTapped : (() -> Void)? = nil
    @IBAction func click2(_ sender: Any) {
        
        if let onButtonDTapped = self.onButtonDTapped{
            onButtonDTapped()
        }
        
    }
    
    
    var onButtonRTapped : (() -> Void)? = nil
    @IBAction func click3(_ sender: Any) {
        
        if let onButtonRTapped = self.onButtonRTapped{
            onButtonRTapped()
        }
        
    }
}
