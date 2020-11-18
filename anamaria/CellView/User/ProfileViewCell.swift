//
//  ProfileViewCell.swift
//  anamaria
//
//  Created by ArturoGR on 9/8/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblEmailTutor: UILabel!
    @IBOutlet weak var lblPhoneTutor: UILabel!
    @IBOutlet weak var lblNameTutor: UILabel!
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
   
    @IBOutlet weak var txtMetas: UITextField!
    @IBOutlet weak var containerTutor: UIView!
    @IBOutlet weak var containerCell: UIView!
    @IBOutlet weak var lblYear: UILabel!
      @IBOutlet weak var lblMetas: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     var onButtonGuardarTapped : (() -> Void)? = nil
    
    @IBAction func btnGuardar(_ sender: Any) {
        
        if let onButtonGuardarTapped = self.onButtonGuardarTapped{
                   onButtonGuardarTapped()
               }
        
    }
}
