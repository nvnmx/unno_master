//
//  PopUpReSheduleController.swift
//  anamaria
//
//  Created by ArturoGR on 8/19/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit
import Parse

protocol PopUpReSheduleControllerProtocol {
    func actualizarCita()
}

class PopUpReSheduleController: UIViewController {
    
    
    
    @IBOutlet weak var btnAceptar: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var lblNotificado: UILabel!
    
    var shedule : PFObject?
    var genDate = Date()
    var firstHour = "00:00"
    var lastHour = "00:00"
    let colorP = UIColor(red:0.44, green:0.31, blue:0.85, alpha:1)
    
    
    var delegate : PopUpReSheduleControllerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        
    }
    
    func setUpData(){
        
        if(getTypeUser())
        {
            lblNotificado.text = "El Nutriólogo será notificado del ajuste de la cita"
        }
        else
            
        {
            lblNotificado.text = "El Paciente será notificado del ajuste de la cita"
        }
        
        btnAceptar.layer.borderWidth = 2.0
        btnAceptar.layer.borderColor = self.colorP.cgColor
        btnAceptar.layer.cornerRadius = 25.0
        
        setCollectionStyle(view: containerView)
        lblDate.text = getTodayString(date: genDate)
        lblHour.text = "\(firstHour)-\(lastHour)"
        
        
        if let user = shedule!.value(forKey: "patient") as? PFUser{
            
            if let name = user.value(forKey: "name") as? String{
                if let last = user.value(forKey: "lastName") as? String{
                    self.lblName.text = "\(name) \(last)"
                }
            }
            
            if let imageFile = user.object(forKey: "avatar") as? PFFileObject{
                if imageFile.url != nil{
                    if let urlString = imageFile.url{
                        let urlFinal = URL(string: urlString)
                        self.userImg.sd_setImage(with: urlFinal)
                        self.userImg.layer.cornerRadius = self.userImg.frame.size.width / 2
                        self.userImg.clipsToBounds = true
                    }
                }
            }
        }
        
    }
    
    
    func getTodayString(date: Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM"
        let currentDateStr = formatter.string(from: date)
        print(currentDateStr)
        return currentDateStr
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func aceptar(_ sender: Any) {
        
        let cita = PFObject(className: "Appointment")
        cita.setValue(firstHour, forKey: "horaInicio")
        cita.setValue(lastHour, forKey: "horaFin")
        let fechaCita = fechaStartDay(date: genDate)
        cita.setValue(fechaCita, forKey: "date")
        cita.setValue(shedule?.objectId, forKey:"objectId")
        
        cita.saveInBackground { (success, error) in
            if(success){
                
                if let user = self.shedule!.value(forKey: "patient") as? PFUser{
                    
                    if let name = user.value(forKey: "name") as? String{
                        
                        let nutriUser = PFUser.current()
                        let nutriologo = nutriUser!.value(forKey: "nutritionist") as? PFUser
                        
                        
                        
                        
                        if (self.getTypeUser())
                        {
                            // si es paciente, ponemos la notificcacion al nutriologo
                            let notiNutriologo = PFObject(className: "Notification")
                            notiNutriologo.setValue(nutriologo, forKey: "user")
                            notiNutriologo.setValue(name, forKey: "userName")
                            notiNutriologo.setValue("act", forKey: "tipo")
                            notiNutriologo.setValue(false, forKey: "isRead")
                            notiNutriologo.setValue(user, forKey: "userCita")
                            notiNutriologo.setValue(self.firstHour + " - " + self.lastHour, forKey: "schedule")
                            
                            notiNutriologo.saveInBackground { (suc,err) in
                                if(suc)
                                {
                                }
                            }
                        }
                        else
                        {
                            // si es nutriologo ponemos la notificacion al paciente
                            let notiPaciente = PFObject(className: "Notification")
                            notiPaciente.setValue(user, forKey: "user")
                            notiPaciente.setValue(name, forKey: "userName")
                            notiPaciente.setValue(false, forKey: "isRead")
                            notiPaciente.setValue(user, forKey: "userCita")
                            notiPaciente.setValue("act", forKey: "tipo")
                            notiPaciente.setValue(self.firstHour + " - " + self.lastHour, forKey: "schedule")
                            
                            notiPaciente.saveInBackground { (suce,erro) in
                                if(suce)
                                {
                                    
                                }
                                else
                                {
                                    
                                }
                            }
                        }
                        
                        
                    }
                    
                }
                self.dismiss(animated: true, completion: nil)
                self.delegate.actualizarCita()
                
            }else{
                self.createAlert(title: "Atención!", message: "No se actualizó la cita correctamente")
            }
        }
        
        
        
        
    }
    
    
}
