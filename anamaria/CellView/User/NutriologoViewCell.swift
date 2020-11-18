//
//  NutriologoViewCell.swift
//  unno
//
//  Created by Bet Data Analysis on 22/09/20.
//  Copyright © 2020 nvn. All rights reserved.
//

import UIKit

class NutriologoViewCell: UITableViewCell {

    @IBOutlet weak var lblMetas: UILabel!
    
    @IBOutlet weak var imgNutriologo: UIImageView!
    
    @IBOutlet weak var lblCedula: UILabel!
    @IBOutlet weak var lblNombre: UILabel!
    
    @IBOutlet weak var lblTelPersonal: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblTelOficina: UILabel!
    @IBOutlet weak var lblEdad: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
