//
//  PorcionesViewController.swift
//  unno
//
//  Created by Bet Data Analysis on 21/07/20.
//  Copyright © 2020 nvn. All rights reserved.
//

import UIKit
import Parse

class PorcionesViewController: UIViewController {
    
    
    
    var citaActual = 0
    

    
    
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var lblFecha: UILabel!
    
    @IBOutlet weak var lblHrDes: UILabel!
    
    @IBOutlet weak var lblDesVer: UILabel!
    
    @IBOutlet weak var lblDesFru: UILabel!
    
    @IBOutlet weak var lblDesCer: UILabel!
    
    @IBOutlet weak var lblDesLeg: UILabel!
    
    @IBOutlet weak var lblDesAlm: UILabel!
    
    @IBOutlet weak var lblDesLac: UILabel!
    
    @IBOutlet weak var lblDesGra: UILabel!
    
    @IBOutlet weak var lblDesGraPro: UILabel!
    
    @IBOutlet weak var lblDesAzu: UILabel!
    
    @IBOutlet weak var lblHrCol1: UILabel!
    
    
    @IBOutlet weak var lblCol1Ver: UILabel!
    
    
    @IBOutlet weak var lblCol1Fru: UILabel!
    
    
    @IBOutlet weak var lblCol1Cer: UILabel!
    
    
    @IBOutlet weak var lblCol1Leg: UILabel!
    
    
    @IBOutlet weak var lblCol1Alm: UILabel!
    
    @IBOutlet weak var lblCol1Lac: UILabel!
    
    @IBOutlet weak var lblCol1Gra: UILabel!
    
    @IBOutlet weak var lblCol1GraPro: UILabel!
    
    @IBOutlet weak var lblCol1Azu: UILabel!
    
    
    @IBOutlet weak var lblHrCom: UILabel!
    
    
    @IBOutlet weak var lblComVer: UILabel!
    
    
    @IBOutlet weak var lblComFru: UILabel!
    
    @IBOutlet weak var lblComCer: UILabel!
    
    @IBOutlet weak var lblComLeg: UILabel!
    
    @IBOutlet weak var lblComAlm: UILabel!
    
    @IBOutlet weak var lblComLac: UILabel!
    
    @IBOutlet weak var lblComGra: UILabel!
    
    @IBOutlet weak var lblComGraPro: UILabel!
    
    @IBOutlet weak var lblComAzu: UILabel!
    
    
    @IBOutlet weak var lblHrCol2: UILabel!
    
    @IBOutlet weak var lblCol2Ver: UILabel!
    
    @IBOutlet weak var lblCol2Fru: UILabel!
    
    @IBOutlet weak var lblCol2Cer: UILabel!
    
    
    @IBOutlet weak var lblCol2Leg: UILabel!
    
    @IBOutlet weak var lblCol2Ali: UILabel!
    
    
    @IBOutlet weak var lblCol2Lac: UILabel!
    
    @IBOutlet weak var lblCol2Gra: UILabel!
    
    @IBOutlet weak var lblCol2GraPro: UILabel!
    
    @IBOutlet weak var lblCol2Azu: UILabel!
    
    @IBOutlet weak var lblHrCen: UILabel!
    
    @IBOutlet weak var lblCenVer: UILabel!
    
    @IBOutlet weak var lblCenFru: UILabel!
    
    @IBOutlet weak var lblCenCer: UILabel!
    
    @IBOutlet weak var lblCenLeg: UILabel!
    
    @IBOutlet weak var lblCenAli: UILabel!
    
    @IBOutlet weak var lblCenLac: UILabel!
    
    @IBOutlet weak var lblCenGra: UILabel!
    
    @IBOutlet weak var lblCenGraPro: UILabel!
    
    @IBOutlet weak var lblCenAzu: UILabel!
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actualizarInformacion()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        actualizarInformacion()
        
    }
    
    
    
    func actualizarInformacion ()
    {
        
        if let user = PFUser.current(){
            
            let query = PFQuery(className:"Appointment")
            query.whereKey("patient", equalTo: user)
            query.order(byDescending: "date")
            query.getFirstObjectInBackground { (cita: PFObject?, error: Error?) in
                if let error = error {
                    // The request failed
                    print(error.localizedDescription)
                } else {
                    
                    if let fecha = cita!.object(forKey: "date") as? Date{
                        self.lblFecha.text = "Última cita: " + self.getTodayString(date: fecha)
                           }
                           
                           if let deshr = cita!.object(forKey: "dh_desayuno_hr") as? String{
                               self.lblHrDes.text = deshr
                           }
                           else
                           {
                               self.lblHrDes.text = ""
                           }
                           
                           if let col1hr = cita!.object(forKey: "dh_colacion1_hr") as? String{
                               self.lblHrCol1.text = col1hr
                           }
                           else
                           {
                               self.lblHrCol1.text = ""
                           }
                           
                           
                           if let comhr = cita!.object(forKey: "dh_comida_hr") as? String{
                               self.lblHrCom.text = comhr
                           }
                           else
                           {
                               self.lblHrCom.text = ""
                           }
                           
                           
                           if let col2hr = cita!.object(forKey: "dh_colacion2_hr") as? String{
                               self.lblHrCol2.text = col2hr
                           }
                           else
                           {
                               self.lblHrCol2.text = ""
                           }
                           
                           if let cenahr = cita!.object(forKey: "dh_cena_hr") as? String{
                               self.lblHrCen.text = cenahr
                           }
                           else
                           {
                               self.lblHrCen.text = ""
                           }
                           
                           if let desver = cita!.object(forKey: "ver_des") as? String{
                               self.lblDesVer.text = desver
                           }
                           else
                           {
                               self.lblDesVer.text = ""
                           }
                           
                           if let vercol1 = cita!.object(forKey: "ver_col1") as? String{
                               self.lblCol1Ver.text = vercol1
                           }
                           else
                           {
                               self.lblCol1Ver.text = ""
                           }
                           
                           
                           if let vercom = cita!.object(forKey: "ver_com") as? String{
                               self.lblComVer.text = vercom
                           }
                           else
                           {
                               self.lblComVer.text = ""
                           }
                           
                           if let vercol2 = cita!.object(forKey: "ver_col2") as? String{
                               self.lblCol2Ver.text = vercol2
                           }
                           else
                           {
                               self.lblCol2Ver.text = ""
                           }
                           if let vercen = cita!.object(forKey: "ver_cen") as? String{
                               self.lblCenVer.text = vercen
                           }
                           else
                           {
                               self.lblCenVer.text = ""
                           }
                           
                           
                           
                           
                           
                           if let desfru = cita!.object(forKey: "fru_des") as? String{
                               self.lblDesFru.text = desfru
                           }
                           else
                           {
                               self.lblDesFru.text = ""
                           }
                           
                           if let frucol1 = cita!.object(forKey: "fru_col1") as? String{
                               self.lblCol1Fru.text = frucol1
                           }
                           else
                           {
                               self.lblCol1Fru.text = ""
                           }
                           
                           
                           if let frucom = cita!.object(forKey: "fru_com") as? String{
                               self.lblComFru.text = frucom
                           }
                           else
                           {
                               self.lblComFru.text = ""
                           }
                           
                           if let frucol2 = cita!.object(forKey: "fru_col2") as? String{
                               self.lblCol2Fru.text = frucol2
                           }
                           else
                           {
                               self.lblCol2Fru.text = ""
                           }
                           if let frucen = cita!.object(forKey: "fru_cen") as? String{
                               self.lblCenFru.text = frucen
                           }
                           else
                           {
                               self.lblCenFru.text = ""
                           }
                           
                           
                           
                           
                           
                           var cerdes = 0
                           if let cersg = cita!.object(forKey: "cer_sg_des") as? String{
                               cerdes = Int(cersg)!
                           }
                           if let cercg = cita!.object(forKey: "cer_cg_des") as? String{
                               cerdes = cerdes + Int(cercg)!
                           }
                           
                           self.lblDesCer.text = String(cerdes)
                           
                           var cercol1 = 0
                           if let cersgcol1 = cita!.object(forKey: "cer_sg_col1") as? String{
                               cercol1 = Int(cersgcol1)!
                           }
                           if let cercgcol1 = cita!.object(forKey: "cer_cg_col1") as? String{
                               cercol1 = cercol1 + Int(cercgcol1)!
                           }
                           
                           self.lblCol1Cer.text = String(cercol1)
                           
                           var cercom = 0
                           if let cersgcom = cita!.object(forKey: "cer_sg_com") as? String{
                               cercom = Int(cersgcom)!
                           }
                           if let cercgcom = cita!.object(forKey: "cer_cg_com") as? String{
                               cercom = cercom + Int(cercgcom)!
                           }
                           
                           self.lblComCer.text = String(cercom)
                           
                           var cercol2 = 0
                           if let cersgcol2 = cita!.object(forKey: "cer_sg_col2") as? String{
                               cercol2 = Int(cersgcol2)!
                           }
                           if let cercgcol2 = cita!.object(forKey: "cer_cg_col2") as? String{
                               cercol2 = cercol2 + Int(cercgcol2)!
                           }
                           
                           self.lblCol2Cer.text = String(cercol2)
                           
                           var cercen = 0
                           if let cersgcen = cita!.object(forKey: "cer_sg_cen") as? String{
                               cercen = Int(cersgcen)!
                           }
                           if let cercgcen = cita!.object(forKey: "cer_cg_cen") as? String{
                               cercen = cercen + Int(cercgcen)!
                           }
                           
                           self.lblCenCer.text = String(cercen)
                           
                           
                           
                           
                           
                           
                           if let desleg = cita!.object(forKey: "leg_des") as? String{
                               self.lblDesLeg.text = desleg
                           }
                           else
                           {
                               self.lblDesLeg.text = ""
                           }
                           
                           if let legcol1 = cita!.object(forKey: "leg_col1") as? String{
                               self.lblCol1Leg.text = legcol1
                           }
                           else
                           {
                               self.lblCol1Leg.text = ""
                           }
                           
                           
                           if let legcom = cita!.object(forKey: "leg_com") as? String{
                               self.lblComLeg.text = legcom
                           }
                           else
                           {
                               self.lblComLeg.text = ""
                           }
                           
                           if let legcol2 = cita!.object(forKey: "leg_col2") as? String{
                               self.lblCol2Leg.text = legcol2
                           }
                           else
                           {
                               self.lblCol2Leg.text = ""
                           }
                           if let legcen = cita!.object(forKey: "leg_cen") as? String{
                               self.lblCenLeg.text = legcen
                           }
                           else
                           {
                               self.lblCenLeg.text = ""
                           }
                           
                           
                           
                           
                           
                           
                           var desalm = 0
                           if let mbagdes = cita!.object(forKey: "mbag_des") as? String{
                               desalm = Int(mbagdes)!
                           }
                           if let bagdes = cita!.object(forKey: "bag_des") as? String{
                               desalm = desalm + Int(bagdes)!
                           }
                           if let magdes = cita!.object(forKey: "mag_des") as? String{
                               desalm = desalm + Int(magdes)!
                           }
                           if let aagdes = cita!.object(forKey: "aag_des") as? String{
                               desalm = desalm + Int(aagdes)!
                           }
                           
                           self.lblDesAlm.text = String(desalm)
                           
                           
                           
                           var col1alm = 0
                           if let mbagdes = cita!.object(forKey: "mbag_col1") as? String{
                               col1alm = Int(mbagdes)!
                           }
                           if let bagdes = cita!.object(forKey: "bag_col1") as? String{
                               col1alm = col1alm + Int(bagdes)!
                           }
                           if let magdes = cita!.object(forKey: "mag_col1") as? String{
                               col1alm = col1alm + Int(magdes)!
                           }
                           if let aagdes = cita!.object(forKey: "aag_col1") as? String{
                               col1alm = col1alm + Int(aagdes)!
                           }
                           
                           self.lblCol1Alm.text = String(col1alm)
                           
                           
                           var comalm = 0
                           if let mbagdes = cita!.object(forKey: "mbag_com") as? String{
                               comalm = Int(mbagdes)!
                           }
                           if let bagdes = cita!.object(forKey: "bag_com") as? String{
                               comalm = comalm + Int(bagdes)!
                           }
                           if let magdes = cita!.object(forKey: "mag_com") as? String{
                               comalm = comalm + Int(magdes)!
                           }
                           if let aagdes = cita!.object(forKey: "aag_com") as? String{
                               comalm = comalm + Int(aagdes)!
                           }
                           
                           self.lblComAlm.text = String(comalm)
                           
                           
                           var col2alm = 0
                           if let mbagdes = cita!.object(forKey: "mbag_col2") as? String{
                               col2alm = Int(mbagdes)!
                           }
                           if let bagdes = cita!.object(forKey: "bag_col2") as? String{
                               col2alm = col2alm + Int(bagdes)!
                           }
                           if let magdes = cita!.object(forKey: "mag_col2") as? String{
                               col2alm = col2alm + Int(magdes)!
                           }
                           if let aagdes = cita!.object(forKey: "aag_col2") as? String{
                               col2alm = col2alm + Int(aagdes)!
                           }
                           
                           self.lblCol2Ali.text = String(col2alm)
                           
                           
                           var cenalm = 0
                           if let mbagdes = cita!.object(forKey: "mbag_cen") as? String{
                               cenalm = Int(mbagdes)!
                           }
                           if let bagdes = cita!.object(forKey: "bag_cen") as? String{
                               cenalm = cenalm + Int(bagdes)!
                           }
                           if let magdes = cita!.object(forKey: "mag_cen") as? String{
                               cenalm = cenalm + Int(magdes)!
                           }
                           if let aagdes = cita!.object(forKey: "aag_cen") as? String{
                               cenalm = cenalm + Int(aagdes)!
                           }
                           
                           self.lblCenAli.text = String(cenalm)
                           
                           
                           var deslac = 0
                           if let mbagdes = cita!.object(forKey: "ldes_des") as? String{
                               deslac = Int(mbagdes)!
                           }
                           if let bagdes = cita!.object(forKey: "lsem_des") as? String{
                               deslac = deslac + Int(bagdes)!
                           }
                           if let magdes = cita!.object(forKey: "lent_des") as? String{
                               deslac = deslac + Int(magdes)!
                           }
                           if let aagdes = cita!.object(forKey: "lcaz_des") as? String{
                               deslac = deslac + Int(aagdes)!
                           }
                           
                           self.lblDesLac.text = String(deslac)
                           
                           
                           
                           var comlac = 0
                           if let mbagdes = cita!.object(forKey: "ldes_com") as? String{
                               comlac = Int(mbagdes)!
                           }
                           if let bagdes = cita!.object(forKey: "lsem_com") as? String{
                               comlac = comlac + Int(bagdes)!
                           }
                           if let magdes = cita!.object(forKey: "lent_com") as? String{
                               comlac = comlac + Int(magdes)!
                           }
                           if let aagdes = cita!.object(forKey: "lcaz_com") as? String{
                               comlac = comlac + Int(aagdes)!
                           }
                           
                           self.lblComLac.text = String(comlac)
                           
                           
                           var cenlac = 0
                           if let mbagdes = cita!.object(forKey: "ldes_cen") as? String{
                               cenlac = Int(mbagdes)!
                           }
                           if let bagdes = cita!.object(forKey: "lsem_cen") as? String{
                               cenlac = cenlac + Int(bagdes)!
                           }
                           if let magdes = cita!.object(forKey: "lent_cen") as? String{
                               cenlac = cenlac + Int(magdes)!
                           }
                           if let aagdes = cita!.object(forKey: "lcaz_cen") as? String{
                               cenlac = cenlac + Int(aagdes)!
                           }
                           
                           self.lblCenLac.text = String(cenlac)
                           
                           
                           var col1lac = 0
                           if let mbagdes = cita!.object(forKey: "ldes_col1") as? String{
                               col1lac = Int(mbagdes)!
                           }
                           if let bagdes = cita!.object(forKey: "lsem_col1") as? String{
                               col1lac = col1lac + Int(bagdes)!
                           }
                           if let magdes = cita!.object(forKey: "lent_col1") as? String{
                               col1lac = col1lac + Int(magdes)!
                           }
                           if let aagdes = cita!.object(forKey: "lcaz_col1") as? String{
                               col1lac = col1lac + Int(aagdes)!
                           }
                           
                           self.lblCol1Lac.text = String(col1lac)
                           
                           
                           var col2lac = 0
                           if let mbagdes = cita!.object(forKey: "ldes_col2") as? String{
                               col2lac = Int(mbagdes)!
                           }
                           if let bagdes = cita!.object(forKey: "lsem_col2") as? String{
                               col2lac = col2lac + Int(bagdes)!
                           }
                           if let magdes = cita!.object(forKey: "lent_col2") as? String{
                               col2lac = col2lac + Int(magdes)!
                           }
                           if let aagdes = cita!.object(forKey: "lcaz_col2") as? String{
                               col2lac = col2lac + Int(aagdes)!
                           }
                           
                           self.lblCol2Lac.text = String(col2lac)
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           if let desleg = cita!.object(forKey: "ag_sp_des") as? String{
                               self.lblDesGra.text = desleg
                           }
                           else
                           {
                               self.lblDesGra.text = ""
                           }
                           
                           if let legcol1 = cita!.object(forKey: "ag_sp_col1") as? String{
                               self.lblCol1Gra.text = legcol1
                           }
                           else
                           {
                               self.lblCol1Gra.text = ""
                           }
                           
                           
                           if let legcom = cita!.object(forKey: "ag_sp_com") as? String{
                               self.lblComGra.text = legcom
                           }
                           else
                           {
                               self.lblComGra.text = ""
                           }
                           
                           if let legcol2 = cita!.object(forKey: "ag_sp_col2") as? String{
                               self.lblCol2Gra.text = legcol2
                           }
                           else
                           {
                               self.lblCol2Gra.text = ""
                           }
                           if let legcen = cita!.object(forKey: "ag_sp_cen") as? String{
                               self.lblCenGra.text = legcen
                           }
                           else
                           {
                               self.lblCenGra.text = ""
                           }
                           
                           
                           
                           
                           
                           if let desleg = cita!.object(forKey: "ag_cp_des") as? String{
                               self.lblDesGraPro.text = desleg
                           }
                           else
                           {
                               self.lblDesGraPro.text = ""
                           }
                           
                           if let legcol1 = cita!.object(forKey: "ag_cp_col1") as? String{
                               self.lblCol1GraPro.text = legcol1
                           }
                           else
                           {
                               self.lblCol1GraPro.text = ""
                           }
                           
                           
                           if let legcom = cita!.object(forKey: "ag_cp_com") as? String{
                               self.lblComGraPro.text = legcom
                           }
                           else
                           {
                               self.lblComGraPro.text = ""
                           }
                           
                           if let legcol2 = cita!.object(forKey: "ag_cp_col2") as? String{
                               self.lblCol2GraPro.text = legcol2
                           }
                           else
                           {
                               self.lblCol2GraPro.text = ""
                           }
                           if let legcen = cita!.object(forKey: "ag_cp_cen") as? String{
                               self.lblCenGraPro.text = legcen
                           }
                           else
                           {
                               self.lblCenGraPro.text = ""
                           }
                           
                           
                           var azudes = 0
                           if let cersg = cita!.object(forKey: "az_sg_des") as? String{
                               azudes = Int(cersg)!
                           }
                           if let cercg = cita!.object(forKey: "az_cg_des") as? String{
                               azudes = azudes + Int(cercg)!
                           }
                           
                           self.lblDesAzu.text = String(azudes)
                           
                           var azucom = 0
                           if let cersg = cita!.object(forKey: "az_sg_com") as? String{
                               azucom = Int(cersg)!
                           }
                           if let cercg = cita!.object(forKey: "az_cg_com") as? String{
                               azucom = azucom + Int(cercg)!
                           }
                           
                           self.lblComAzu.text = String(azucom)
                           
                           
                           var azucen = 0
                           if let cersg = cita!.object(forKey: "az_sg_cen") as? String{
                               azucen = Int(cersg)!
                           }
                           if let cercg = cita!.object(forKey: "az_cg_cen") as? String{
                               azucen = azucen + Int(cercg)!
                           }
                           
                           self.lblCenAzu.text = String(azucen)
                           
                           
                           var azucol1 = 0
                           if let cersg = cita!.object(forKey: "az_sg_col1") as? String{
                               azucol1 = Int(cersg)!
                           }
                           if let cercg = cita!.object(forKey: "az_cg_col1") as? String{
                               azucol1 = azucol1 + Int(cercg)!
                           }
                           
                           self.lblCol1Azu.text = String(azucol1)
                           
                           
                           var azucol2 = 0
                           if let cersg = cita!.object(forKey: "az_sg_col2") as? String{
                               azucol2 = Int(cersg)!
                           }
                           if let cercg = cita!.object(forKey: "az_cg_col2") as? String{
                               azucol2 = azucol2 + Int(cercg)!
                           }
                           
                           self.lblCol2Azu.text = String(azucol2)
                    
                }
            }
            
        }
        
        

        
       
        
        
    }
    
    
    func getTodayString(date: Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //formatter.timeStyle = .long
        // formatter.amSymbol = "AM"
        //formatter.pmSymbol = "PM"
        let currentDateStr = formatter.string(from: date)
        print(currentDateStr)
        return currentDateStr
    }
    
    
    
}
