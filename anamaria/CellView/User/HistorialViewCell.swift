//
//  HistorialViewCell.swift
//  unno
//
//  Created by Bet Data Analysis on 07/08/20.
//  Copyright © 2020 nvn. All rights reserved.
//

import UIKit

class HistorialViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var lblPapaniTit: UILabel!
    @IBOutlet weak var lblSexualmente: UILabel!
    @IBOutlet weak var lblSexualmenteTit: UILabel!
    @IBOutlet weak var lblEnfermedades: UILabel!
    
    @IBOutlet weak var lblPapanicolao: UILabel!
    @IBOutlet weak var lblFUM: UILabel!
    @IBOutlet weak var lblFumTit: UILabel!
    
    @IBOutlet weak var lblAF: UILabel!
    @IBOutlet weak var lblPMSTit: UILabel!
    @IBOutlet weak var lblDrogas: UILabel!
    @IBOutlet weak var lblTabaco: UILabel!
    @IBOutlet weak var lblCirugias: UILabel!
    @IBOutlet weak var lblHospitalizacion: UILabel!
    @IBOutlet weak var lblPMS: UILabel!
    
    @IBOutlet weak var lblAlcohol: UILabel!
    @IBOutlet weak var lblMedicamentos: UILabel!
    @IBOutlet weak var lblGrupoSanguineo: UILabel!
    @IBOutlet weak var lblHerencias: UILabel!
    @IBOutlet weak var lblAlergias: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
