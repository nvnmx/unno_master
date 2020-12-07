//
//  AddPatientViewController.swift
//  anamaria
//
//  Created by Francisco Constante on 1/13/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit
import Parse

protocol AddPatientViewControllerProtocol {
    func actualizarInfo()
}

class AddPatientViewController: UIViewController {
    
    var delegateNuevoPaciente : AddPatientViewControllerProtocol!
    
    @IBOutlet weak var btnTutor: UIButton!
    let colorP = UIColor(red:0.44, green:0.31, blue:0.85, alpha:1)
    
    var genre = "female"
    
    @IBOutlet weak var ttEmailAdd: UITextField!
    @IBOutlet weak var ttNameAdd: UITextField!
    @IBOutlet weak var ttPhone: UITextField!
      @IBOutlet weak var ttMetas: UITextField!
    @IBOutlet weak var ttLast: UITextField!
    @IBOutlet weak var ttAge: UITextField!
    @IBOutlet weak var ttPass: UITextField!
    @IBOutlet weak var btSave: UIButton!
    @IBOutlet weak var btnWoman: UIButton!
    @IBOutlet weak var btnMen: UIButton!
    
    
    @IBAction func savePatient(_ sender: Any) {
        validateUserInput()
    }
    
    @IBAction func setMen(_ sender: Any) {
        genre = "male"
        self.btnMen.setImage(UIImage(named: "btn_male_on"), for: UIControl.State.normal)
        self.btnWoman.setImage(UIImage(named: "btn_female"), for: UIControl.State.normal)
    }
    
    @IBAction func setWoman(_ sender: Any) {
        genre = "female"
        self.btnMen.setImage(UIImage(named: "btn_male"), for: UIControl.State.normal)
        self.btnWoman.setImage(UIImage(named: "btn_female_on"), for: UIControl.State.normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBtnStyle(view: self.btSave)
    }
    
    @IBAction func close(_ sender: Any) {
        print("ENTROCLICK \(btnTutor.isSelected)")
        self.dismiss(animated: true, completion: nil)
    }
    func validateUserInput(){
        
        let decimalC = CharacterSet.decimalDigits
        
        let decimalR = ttNameAdd.text?.rangeOfCharacter(from: decimalC)
        
        let decimalL = ttLast.text?.rangeOfCharacter(from: decimalC)
        
        if decimalR != nil || decimalL != nil
        {
            self.createAlert(title: "Alerta", message: "No se permiten números en Nombre y Apellidos")
        }
        else
        {
            
            if(ttEmailAdd.text! != "" && ttNameAdd.text! != "" && ttPhone.text! != "" && ttLast.text! != "" && ttAge.text! != ""){ //&& ttPass.text! != ""
                
                let edad = Int(ttAge.text!) ?? 0
                if edad > 0
                {
                    
                    if(self.isValidEmail(testStr: ttEmailAdd.text!)){
                        
                        if(self.ttPhone.text!.count > 6 && self.ttPhone.text!.count < 11){
                            //patient
                            let user = PFObject(className: "UserPatient")
                            
                            user.setValue(ttEmailAdd.text!, forKey: "username")
                            user.setValue(ttEmailAdd.text!, forKey: "password")
                            user.setValue(ttEmailAdd.text!, forKey:"email")
                            
                            user.setValue(ttPhone.text!, forKey: "phone")
                            user.setValue(ttAge.text!, forKey: "age")
                            user.setValue(ttLast.text!, forKey:"lastName")
                            user.setValue(genre, forKey:"genre")
                            user.setValue(ttNameAdd.text!, forKey:"name")
                            user.setValue("patient", forKey:"typeUser")
                           // user.setValue(ttMetas.text!, forKey:"golds")
                            user.setValue(PFUser.current(), forKey:"nutritionist")
                            user.setValue(PFUser.current()?.objectId, forKey:"nutritionistId")
                            user.setValue(btnTutor.isSelected, forKey:"isTutor")
                            
                            user.saveInBackground { (success, error) in
                                if let error = error {
                                    self.createAlert(title: "Atención", message: "Error al crear paciente")
                                    print("Signup error: \(error.localizedDescription)")
                                } else {
                                    
                                    self.dismiss(animated: true, completion: nil)
                                    self.delegateNuevoPaciente.actualizarInfo()
                                }
                            }         
                        }else{
                            self.createAlert(title: "Alerta", message: "Ingrese un teléfono correcto (7 a 10 dígitos)")
                        }
                    }else{
                        self.createAlert(title: "Alerta", message: "Ingrese un e-mail válido")
                    }
                }
                else
                {
                    self.createAlert(title: "Alerta", message: "La edad debe de ser mayor a 0")
                }
            }else{
                self.createAlert(title: "Alerta", message: "Ingrese todos los campos")
            }
        }
    }
    
    
    @IBAction func clickTutor(_ sender: Any) {
        print("ENTROCLICK \(btnTutor.isSelected)")
        if(!btnTutor.isSelected){
            btnTutor.isSelected = true
            btnTutor.setImage(UIImage(named: "switch_on"), for: .selected)
        }else{
            btnTutor.isSelected = false
            btnTutor.setImage(UIImage(named: "switch_off_complete"), for: .disabled)
        }
        
    }
    
    
}
