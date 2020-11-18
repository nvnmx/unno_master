//
//  ViewController.swift
//  anamaria
//
//  Created by Francisco on 10/7/18.
//  Copyright © 2018 nvn. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    
    
    
    
    
    var passwordRecovery = false
    @IBOutlet weak var btnEnter: UIButton!
    @IBOutlet weak var btnForfet: UIButton!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lbForgoten: UILabel!
    @IBOutlet weak var lbError: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBAction func goForgotPassword(_ sender: Any) {
        //btnEnter.setTitle("ENVIAR",for: .normal)
        
        txtPassword.isHidden = true
        viewPassword.isHidden = true
        btnForfet.isHidden = true
        btnBack.isHidden = false
        lbForgoten.isHidden = false
        lbError.isHidden = true
        passwordRecovery = true
        
        
        txtUser.text = ""
        txtPassword.text = ""
        self.viewUser.backgroundColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:0.3)
        self.viewPassword.backgroundColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:0.3)
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dissmisKeyboard))
               view.addGestureRecognizer(tap)
        
    }
    
    @objc func dissmisKeyboard(){
          view.endEditing(true)
      }
    @IBAction func enterLogIn(_ sender: Any) {
        if(passwordRecovery){
            
            if(self.isValidEmail(testStr: txtUser.text!)){
                PFUser.requestPasswordResetForEmail(inBackground: txtUser.text!) { (success, error) -> Void in
                    if (error == nil) {
                        
                        //#00A2C7 UIColor(red:0.00, green:0.64, blue:0.78, alpha:1.0)
                        self.lbError.isHidden = false
                        self.lbError.text = "Correo enviado correctamente"
                        self.lbError.textColor = UIColor(red:0.00, green:0.64, blue:0.78, alpha:1.0)
                        self.viewUser.backgroundColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:0.3)
                        self.txtUser.text = ""
                        
                        
                    }else {
                        self.lbError.isHidden = false
                        self.lbError.text = "Error recuperar contraseña \(String(describing: error))"
                        self.viewUser.backgroundColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
                        self.lbError.textColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
                    }
                }
                
            }else{
                lbError.isHidden = false
                lbError.text = "Ingrese correo válido"
                viewUser.backgroundColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
                self.lbError.textColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
            }
        }else{
            if(txtUser.text! != "" && txtPassword.text! != ""){
                if(self.isValidEmail(testStr: txtUser.text!)){
                    PFUser.logInWithUsername(inBackground: txtUser.text!, password: txtPassword.text!) { (user, error) in
                        
                        if(user != nil){
                            self.lbError.isHidden = true
                            self.lbError.isHidden = false
                            self.lbError.text = "Ingreso correcto"
                            self.lbError.textColor = UIColor(red:0.00, green:0.64, blue:0.78, alpha:1.0)
                            self.viewUser.backgroundColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:0.3)
                            self.txtUser.text = ""
                            self.viewPassword.backgroundColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:0.3)
                            self.txtPassword.text = ""
                            
                            let currentInstallation = PFInstallation.current()
                            currentInstallation!.addUniqueObject("user_"+(user?.objectId!)!, forKey: "channels")
                            currentInstallation!.saveInBackground()
                            
                            let destination = self.storyboard!.instantiateViewController(withIdentifier: "main")
                            destination.modalPresentationStyle = .fullScreen
                            self.show(destination, sender: nil)
                            
                        }else{
                            if(error?.localizedDescription == "Invalid username/password."){
                                self.lbError.isHidden = false
                                self.lbError.text = "Correo o Contraseña incorrectos"
                                self.lbError.textColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
                                
                            }else{
                                let parseError = (error! as NSError).userInfo["code"] as? Int
                                self.lbError.isHidden = false
                                self.lbError.text = "Error \(String(describing: parseError))"
                                self.viewUser.backgroundColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
                                self.viewPassword.backgroundColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
                                self.lbError.textColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
                            }
                        }
                    }
                }else{
                    lbError.isHidden = false
                    lbError.text = "Ingrese e-mail válido"
                    self.lbError.textColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
                    self.viewUser.backgroundColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
                    self.viewPassword.backgroundColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:0.3)
                }
            }else{
                lbError.isHidden = false
                lbError.text = "Ingrese e-mail y contraseña"
                self.lbError.textColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
                self.viewUser.backgroundColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
                self.viewPassword.backgroundColor = UIColor(red:1, green:0.2, blue:0.4, alpha:1)
            }
        }
    }
    @IBAction func backLogin(_ sender: Any) {
        passwordRecovery = false
       // btnEnter.setTitle("INGRESAR",for: .normal)
        
        txtPassword.isHidden = false
        viewPassword.isHidden = false
        btnForfet.isHidden = false
        btnBack.isHidden = true
        lbForgoten.isHidden = true
        lbError.isHidden = true
        
        txtUser.text = ""
        txtPassword.text = ""
        
        self.viewUser.backgroundColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:0.3)
        self.viewPassword.backgroundColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:0.3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBtnStyle(view: self.btnEnter)
    }
}
