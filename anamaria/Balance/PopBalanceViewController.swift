//
//  PopBalanceViewController.swift
//  anamaria
//
//  Created by Francisco Constante on 3/12/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit
import Parse


  protocol PopBalanceViewControllerProtocol {
    func actualizarMontos()
}

class PopBalanceViewController: UIViewController {
    
    var type = "income"
    
     var delegate : PopBalanceViewControllerProtocol!

    @IBAction func closePopBalance(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePop(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var viewPopBalnce: UIView!
    @IBOutlet weak var txtConcept: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var typeBalance: UISegmentedControl!
    @IBOutlet weak var btnSave: UIButton!
    

    @IBAction func saveAction(_ sender: Any) {
        let amount = self.txtAmount.text ?? "0"
        
        if(Int(amount) == 0){
            self.createAlert(title: "Alerta", message: "La cantidad no es válida")
            return
        }
        
        
        if(self.txtConcept.text != "" && self.txtAmount.text != ""){
            let bal = PFObject(className: "Balance")
            bal.setValue(type, forKey: "type")
            bal.setValue(Int(amount), forKey: "amount")
            bal.setValue(self.txtConcept.text!, forKey: "concept")
            bal.setValue(PFUser.current(), forKey: "nutriologoId")
            bal.saveInBackground { (success, error) in
                if(success){
                    self.dismiss(animated: true, completion: nil)
                    self.delegate.actualizarMontos()
                }else{
                    self.createAlert(title: "Error", message: "No se guardó el balance correctamente")
                }
            }
        }else{
            self.createAlert(title: "Alerta", message: "Ingrese concepto y cantidad para continuar")
        }
        
    }
    
    @IBAction func incomeOutput(_ sender: Any) {
        let t = self.typeBalance.selectedSegmentIndex
        
        switch t {
        case 0:
            type = "income"
        case 1:
            type = "outcome"
        default:
            type = "income"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewPopBalnce.layer.cornerRadius = 10
        self.viewPopBalnce.layer.masksToBounds = true
        self.setBtnStyle(view: self.btnSave)
       
    }
}
