//
//  MediblesViewController.swift
//  unno
//
//  Created by Bet Data Analysis on 21/07/20.
//  Copyright © 2020 nvn. All rights reserved.
//

import UIKit
import Parse

class MediblesViewController: UIViewController {
    
    var citasList = [PFObject] ()
    
    var citaActual = 0
    
    
    @IBOutlet weak var lblTalla: UILabel!
    @IBOutlet weak var lblPeso: UILabel!
    
    @IBOutlet weak var lblIMC: UILabel!
    
    @IBOutlet weak var lblFecha: UILabel!
    
    @IBOutlet weak var lblPesoMin: UILabel!
    
    @IBOutlet weak var lblPEsoTeoricoV: UILabel!
    
    @IBOutlet weak var lblPesoMax: UILabel!
    
    @IBOutlet weak var lblPesoTeoricoP: UILabel!
    
    @IBOutlet weak var btnAnterior: UIButton!
    @IBOutlet weak var btnSiguiente: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actualizarInformacion()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        actualizarInformacion()
    }
    
    @IBAction func btnAnterior(_ sender: Any) {
        
        if citaActual > 0
        {
            
            citaActual = citaActual - 1
            actualizarInformacion()
        }
        
        
        
    }
    
    
    @IBAction func btnSiguiente(_ sender: Any) {
        
        if citaActual < citasList.count - 1
        {
            
            citaActual = citaActual + 1
            actualizarInformacion()
        }
        
        
        
    }
    
    
    func actualizarInformacion ()
    {
        if citaActual == 0
        {
            btnAnterior.isHidden = true
            btnSiguiente.isHidden = false
        }
        else if citaActual == citasList.count - 1
        {
            btnAnterior.isHidden = false
            btnSiguiente.isHidden = true
        }
        else
        {
            btnAnterior.isHidden = false
            btnSiguiente.isHidden = false
        }
        
        
        
        let cita = citasList[citaActual]
        
        if let fecha = cita.object(forKey: "date") as? Date{
            lblFecha.text = getTodayString(date: fecha)
        }
        
        if let pesoMin = cita.object(forKey: "pesoMin") as? String{
            lblPesoMin.text = pesoMin
        }
        else
        {
            lblPesoMin.text = ""
        }
        
        if let pesoMax = cita.object(forKey: "pesoMax") as? String{
            lblPesoMax.text = pesoMax
        }
        else
        {
            lblPesoMax.text = ""
        }
        
        
        if let peso = cita.object(forKey: "peso") as? String{
            lblPeso.text = peso
        }
        else
        {
            lblPeso.text = ""
        }
        
        
        if let pesoTeoricoV = cita.object(forKey: "pesoTeoricoV") as? String{
            lblPEsoTeoricoV.text = pesoTeoricoV
        }
        else
        {
            lblPEsoTeoricoV.text = ""
        }
        
        if let pesoTeoricoP = cita.object(forKey: "pesoTeoricoP") as? String{
            lblPesoTeoricoP.text = pesoTeoricoP
        }
        else
        {
            lblPesoTeoricoP.text = ""
        }
        
        if let imc = cita.object(forKey: "imc") as? String{
            lblIMC.text = imc
        }
        else
        {
            lblIMC.text = ""
        }
        
        if let talla = cita.object(forKey: "talla") as? String{
            lblTalla.text = talla
        }
        else
        {
            lblTalla.text = ""
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
