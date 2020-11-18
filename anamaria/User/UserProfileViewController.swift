//
//  UserProfileViewController.swift
//  anamaria
//
//  Created by ArturoGR on 9/6/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit
import Parse


protocol UserProfileViewControllerProtocol {
    func actualizarInfo()
}

class UserProfileViewController: UIViewController, ReSheduleViewControllerProtocol,SheduleViewControllerProtocol {
    
    
    
    var delegateUserProfile : UserProfileViewControllerProtocol!
    
    var pacienteUser: PFUser?
    var tutor: PFUser?
    var cita: PFObject?
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var btnCitas: UIButton!
    @IBOutlet weak var btnHistorial: UIButton!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewCitas: UIView!
    @IBOutlet weak var viewHistorial: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPaciente: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgCita: UIImageView!
    @IBOutlet weak var imgUnno: UIImageView!
    @IBOutlet weak var imgHistorial: UIImageView!
    @IBOutlet weak var containerSettings: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnBackImg: UIImageView!
    
    var viewSel = "User"
    var isPatient = false
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeColor(colorUser: .black, colorCita: UIColor.lightGray,colorHistorial:  UIColor.lightGray)
        setUpData()
        if(isPatient){
            btnBack.isHidden = true
            containerSettings.isHidden = false
            
            lblTitle.text = "Citas"
            viewSel = "Citas"
            viewCitas.isHidden = false
            viewUser.isHidden = true
            lblPaciente.isHidden = true
            imgUnno.isHidden = false
            btnBack.isHidden = true
            btnBackImg.isHidden = true
            
            self.changeColor(colorUser: UIColor.lightGray, colorCita: .black,colorHistorial:  UIColor.lightGray)
        }
        else{
            lblPaciente.isHidden = false
            imgUnno.isHidden = true
            btnBack.isHidden = false
            btnBackImg.isHidden = false
        }
        
    }
    
    @IBAction func settings(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = pacienteUser{
            self.getCita(success: { (citaPF) in
                self.cita = citaPF
                
                DispatchQueue.main.async( execute: {
                    self.tableView.reloadData()
                })
                
            }, errorCode: { (error) in
                DispatchQueue.main.async( execute: {
                    self.tableView.reloadData()
                })
            }, patient: user)
        }
    }
    
    func actualizarCitas() {
       actualizarTodo()
    }
    
    func actualizarTodo(){
        if let user = pacienteUser{
            self.getCita(success: { (citaPF) in
                self.cita = citaPF
                
                DispatchQueue.main.async( execute: {
                    self.tableView.reloadData()
                })
                
            }, errorCode: { (error) in
                DispatchQueue.main.async( execute: {
                    self.tableView.reloadData()
                })
            }, patient: user)
        }
    }
    
    
    func seActualizoCita() {
        actualizarTodo()
    }
    
    func setUpData(){
        self.cita = nil
        if let user = pacienteUser{
            if let tutor = user.value(forKey: "tutor") as? String{
                
                self.getTutor(success: { (userTutor) in
                    self.tutor = userTutor
                    
                    
                    self.getCita(success: { (citaPF) in
                        self.cita = citaPF
                        
                        DispatchQueue.main.async( execute: {
                            self.tableView.reloadData()
                        })
                        
                    }, errorCode: { (error) in
                        DispatchQueue.main.async( execute: {
                            self.tableView.reloadData()
                        })
                    }, patient: user)
                }, errorCode: { (error) in
                    
                }, objectId: tutor)
                
            }
            
            
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true
            , completion: nil)
        if (self.delegateUserProfile != nil)
        {
            self.delegateUserProfile.actualizarInfo()
        }
    }
    
    @IBAction func user(_ sender: Any) {
        lblTitle.text = "Perfil"
        viewSel = "User"
        viewUser.isHidden = false
        viewCitas.isHidden = true
        viewHistorial.isHidden = true
        self.changeColor(colorUser: .black, colorCita: UIColor.lightGray,colorHistorial:  UIColor.lightGray)
        
    }
    @IBAction func citas(_ sender: Any) {
        lblTitle.text = "Citas"
        viewSel = "Citas"
        viewCitas.isHidden = false
        viewUser.isHidden = true
        viewHistorial.isHidden = true
        self.changeColor(colorUser: UIColor.lightGray, colorCita: .black,colorHistorial:  UIColor.lightGray)
    }
    
    @IBAction func historial(_ sender: Any) {
        lblTitle.text = "Historial Clínico"
        viewSel = "Historial"
        viewHistorial.isHidden = false
        viewUser.isHidden = true
        viewCitas.isHidden = true
        self.changeColor(colorUser: UIColor.lightGray, colorCita: UIColor.lightGray,colorHistorial:  .black)
    }
    
    func changeColor(colorUser: UIColor, colorCita: UIColor, colorHistorial: UIColor){
        
        let image = UIImage(named: "icon_profile_K")?.withRenderingMode(.alwaysTemplate)
        imgUser.image = image
        imgUser.tintColor = colorUser
        
        let image2 = UIImage(named: "icon_calendar_K")?.withRenderingMode(.alwaysTemplate)
        imgCita.image = image2
        imgCita.tintColor = colorCita
        
        let image3 = UIImage(named: "h")?.withRenderingMode(.alwaysTemplate)
        imgHistorial.image = image3
        imgHistorial.tintColor = colorHistorial
        
        tableView.reloadData()
        
    }
}


extension UserProfileViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(viewSel == "User"){
            return 600
        }else if ( viewSel == "Citas"){
            return 210
        } else
        {
            return 1436
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(viewSel == "User"){
            
            if (isPatient)
            {
                btnBack.isHidden = true
                lblTitle.text = "Nutriólogo"
                let cell = Bundle.main.loadNibNamed("NutriologoViewCell", owner: self, options: nil)?.first as! NutriologoViewCell
                
                
                
                
                if let user = self.pacienteUser{
                    
                    if let nutId = user.value(forKey: "nutritionistId") as? String{
                        
                        let query = PFQuery(className:"_User")
                        
                        query.whereKey("objectId", equalTo: nutId)
                        query.getFirstObjectInBackground { (nutriologo, error) in
                            if(error == nil){
                                
                                if let name = nutriologo!.value(forKey: "name") as? String{
                                    if let last = nutriologo!.value(forKey: "lastName") as? String{
                                        cell.lblNombre.text = "\(name) \(last)"
                                    }
                                }
                                
                                if let cedula = nutriologo!.value(forKey: "cedulaProfesional") as? String{
                                    cell.lblCedula.text = cedula
                                }
                                else
                                {
                                    cell.lblCedula.text = ""
                                }
                                if let telCasa = nutriologo!.value(forKey: "phone") as? String{
                                    cell.lblTelPersonal.text = telCasa
                                }
                                else
                                {
                                    cell.lblTelPersonal.text = ""
                                }
                                if let oficina = nutriologo!.value(forKey: "telefonoOficina") as? String{
                                    cell.lblTelOficina.text = oficina
                                }
                                else
                                {
                                    cell.lblTelOficina.text = ""
                                }
                                if let email = nutriologo!.value(forKey: "email") as? String{
                                    cell.lblEmail.text = email
                                }
                                else
                                {
                                    cell.lblEmail.text = ""
                                }
                                
                                if let edad = nutriologo!.value(forKey: "age") as? String{
                                    cell.lblEdad.text = edad
                                }
                                else
                                {
                                    cell.lblEdad.text = ""
                                }
                                if let imageFile = nutriologo!.object(forKey: "avatar") as? PFFileObject{
                                    if imageFile.url != nil{
                                        if let urlString = imageFile.url{
                                            let urlFinal = URL(string: urlString)
                                            cell.imgNutriologo.sd_setImage(with: urlFinal)
                                            cell.imgNutriologo.layer.cornerRadius = cell.imgNutriologo.frame.size.width / 2
                                            cell.imgNutriologo.clipsToBounds = true
                                        }
                                    }
                                }
                            }
                            else
                            {
                                
                            }
                            
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    let query = PFQuery(className:"DetallePaciente")
                    
                    query.whereKey("userId", equalTo: user)
                    query.getFirstObjectInBackground { (usuarioDet, error) in
                        if(error == nil){
                            if let metas = usuarioDet!.value(forKey: "metas") as? String{
                                cell.lblMetas.text = metas
                            }
                        }
                        else
                        {
                            cell.lblMetas.text = ""
                        }
                    }
                    
                    
                    
                    
                    
                }
                
                return cell
            }
            else
            {
                btnBack.isHidden = false
                lblTitle.text = "Paciente"
                let cell = Bundle.main.loadNibNamed("ProfileViewCell", owner: self, options: nil)?.first as! ProfileViewCell
                
                setCardStyle(view: cell.containerCell)
                
                
                if let user = self.pacienteUser{
                    
                    
                    
                    if let _ = user.value(forKey: "tutor") as? String{
                        
                        if let userTutor = self.tutor{
                            
                            if let nameTutor = userTutor.value(forKey: "name") as? String{
                                if let lastTutor = userTutor.value(forKey: "lastName") as? String{
                                    cell.lblNameTutor.text = "\(nameTutor) \(lastTutor)"
                                }
                            }
                            
                            if let mailTutor = userTutor.value(forKey: "mail") as? String{
                                cell.lblEmailTutor.text = mailTutor
                            }
                            
                            if let phoneTutor = userTutor.value(forKey: "phone") as? String{
                                cell.lblPhoneTutor.text = phoneTutor
                            }
                        }
                        
                        
                    }else{
                        cell.containerTutor.isHidden = true
                    }
                    
                    
                    if let name = user.value(forKey: "name") as? String{
                        if let last = user.value(forKey: "lastName") as? String{
                            cell.lblName.text = "\(name) \(last)"
                        }
                    }
                    
                    if let mail = user.value(forKey: "username") as? String{
                        cell.email.text = mail
                    }
                    
                    if let phone = user.value(forKey: "phone") as? String{
                        cell.phone.text = phone
                    }
                    
                    let query = PFQuery(className:"DetallePaciente")
                    
                    query.whereKey("userId", equalTo: user)
                    query.getFirstObjectInBackground { (usuarioDet, error) in
                        if(error == nil){
                            if let metas = usuarioDet!.value(forKey: "metas") as? String{
                                cell.txtMetas.text = metas
                            }
                        }
                        else
                        {
                            cell.txtMetas.text = ""
                        }
                    }
                    
                    cell.onButtonGuardarTapped = {
                        
                        
                        let query = PFQuery(className:"DetallePaciente")
                        
                        query.whereKey("userId", equalTo: user)
                        query.getFirstObjectInBackground { (detalle, error) in
                            if(error == nil){
                                
                                let metas = cell.txtMetas.text
                                if let idDetalle = detalle!.value(forKey: "objectId") as? String{
                                    cell.txtMetas.text = metas
                                
                                let detallePac = PFObject(className: "DetallePaciente")
                                detallePac.setValue(metas, forKey: "metas")
                                detallePac.setValue(idDetalle, forKey: "objectId")
                                
                                detallePac.saveInBackground { (suc,err) in
                                    if(suc)
                                    {
                                        
                                        
                                    }
                                }
                                }
                                
                                
                            }
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    if let age = user.value(forKey: "age") as? String{
                        cell.lblYear.text = age
                    }
                    
                    if let imageFile = user.object(forKey: "avatar") as? PFFileObject{
                        if imageFile.url != nil{
                            if let urlString = imageFile.url{
                                let urlFinal = URL(string: urlString)
                                cell.imgUser.sd_setImage(with: urlFinal)
                                cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width / 2
                                cell.imgUser.clipsToBounds = true
                            }
                        }
                    }
                }
                
                return cell
            }
        }else if (viewSel == "Citas"){
            
            
            
            
            
            let cell = Bundle.main.loadNibNamed("CitaViewCell", owner: self, options: nil)?.first as! CitaViewCell
            
            
            if (isPatient)
            {
                cell.viewBtnNuevo.isHidden = true
                
            }
            else
            {
                cell.viewBtnNuevo.isHidden = false
                
            }
            
            
            setCardStyleBtn(view: cell.reShedule)
            setCardStyleBtn(view: cell.delete)
            setCardStyleBtn(view: cell.btnMore)
            setCardStyle(view: cell.containerCell)
            
            if let cita = self.cita{
                cell.viewBtnNuevo.isHidden = true
                cell.reloj.isHidden = true
                if var date = cita.value(forKey: "date") as? Date{
                    date = regresarFecha(date: date)
                    cell.lblDate.text = self.getTodayString(date: date)
                }
                
                if let start = cita.value(forKey: "horaInicio") as? String{
                    if let end = cita.value(forKey: "horaFin") as? String{
                        cell.lblHour.text = "\(start) — \(end)"
                        cell.reloj.isHidden = false
                    }
                }
                
                
                cell.onButtonTapped = {
                    let destination = self.storyboard?.instantiateViewController(withIdentifier: "ReSheduleViewController") as! ReSheduleViewController
                    destination.shedule = cita
                    destination.delegate = self
                    self.show(destination, sender: nil)
                }
                
               
                
                cell.onButtonDTapped = {
                    
                    if let user = cita.value(forKey: "patient") as? PFUser{
                        
                        let horaInicio = cita.value(forKey: "horaInicio") as? String
                        let horaFin = cita.value(forKey: "horaFin") as? String
                        
                        if let name = user.value(forKey: "name") as? String{
                            
                           let nutriUser = PFUser.current()
                            let nutriologo = nutriUser!.value(forKey: "nutritionist") as? PFUser
                            
                            if (self.getTypeUser())
                            {
                                // si es paciente, ponemos la notificcacion al nutriologo
                                let notiNutriologo = PFObject(className: "Notification")
                                notiNutriologo.setValue(nutriologo, forKey: "user")
                                notiNutriologo.setValue(name, forKey: "userName")
                                notiNutriologo.setValue("eli", forKey: "tipo")
                                notiNutriologo.setValue(false, forKey: "isRead")
                                notiNutriologo.setValue(user, forKey: "userCita")
                                notiNutriologo.setValue(horaInicio! + " - " + horaFin!, forKey: "schedule")
                                
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
                                notiPaciente.setValue("eli", forKey: "tipo")
                                notiPaciente.setValue(horaInicio! + " - " + horaFin!, forKey: "schedule")
                                
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
                    
                    
                    cita.deleteInBackground()
                    
                    if let user = self.pacienteUser{
                        self.cita = nil
                        self.getCita(success: { (citaPF) in
                            self.cita = citaPF
                            DispatchQueue.main.async( execute: {
                                self.tableView.reloadData()
                            })
                            
                        }, errorCode: { (error) in
                            DispatchQueue.main.async( execute: {
                                self.tableView.reloadData()
                            })
                        }, patient: user)
                    }
                    
                }
                
            }else{
                cell.lblTitle.isHidden = true
                cell.lblNoHay.isHidden = false
                cell.reShedule.isHidden = true
                cell.delete.isHidden = true
                cell.btnMore.isHidden = false
                
                if(getTypeUser())
                {
                    cell.viewBtnNuevo.isHidden = true
                }
                else
                {
                    cell.viewBtnNuevo.isHidden = false
                }
                
                cell.onButtonRTapped = {
                    if let user = self.pacienteUser{
                        if let idPaciente = user.value(forKey: "objectId") as? String{
                        let destination = self.storyboard?.instantiateViewController(withIdentifier: "SheduleViewController") as! SheduleViewController
                        destination.delegate = self
                        destination.paciente = idPaciente
                        self.show(destination, sender: nil)
                        }
                    }
                }
            }
            
            
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("HistorialViewCell", owner: self, options: nil)?.first as! HistorialViewCell
            
            var hombre = true
            if let genero = pacienteUser!.value(forKey: "genre") as? String{
                if genero == "female"
                {
                    hombre = false
                }
            }
            
            if hombre
            {
                cell.lblPapanicolao.isHidden = true
                cell.lblPapaniTit.isHidden = true
                cell.lblSexualmente.isHidden = true
                cell.lblSexualmenteTit.isHidden = true
                cell.lblPMS.isHidden = true
                cell.lblPMSTit.isHidden = true
                cell.lblFUM.isHidden = true
                cell.lblFumTit.isHidden = true
            }
            
            
            let query = PFQuery(className:"DetallePaciente")
            
            query.whereKey("userId", equalTo: pacienteUser)
            do
            {
                
                let detalle =  try query.getFirstObject()
                if let enfermedades = detalle.value(forKey: "enfermedades") as? String{
                    cell.lblEnfermedades.text = enfermedades
                }
                
                if let enfermedades = detalle.value(forKey: "depoaficion") as? String{
                    cell.lblAF.text = enfermedades
                }
                
                var apetitononulo = ""
                if let apetito = detalle.value(forKey: "apetito") as? String{
                    apetitononulo = apetito
                }
                
                if let pms = detalle.value(forKey: "pms") as? String{
                    cell.lblPMS.text = pms + " " + apetitononulo
                }
                
                if let drogas = detalle.value(forKey: "drogas") as? String{
                    cell.lblDrogas.text = drogas
                }
                
                if let tabaco = detalle.value(forKey: "tabaco") as? String{
                    cell.lblTabaco.text = tabaco
                }
                
                if let alcohol = detalle.value(forKey: "alcohol") as? String{
                    cell.lblAlcohol.text = alcohol
                }
                
                if let alergias = detalle.value(forKey: "alergias") as? String{
                    cell.lblAlergias.text = alergias
                }
                
                
                if let cirugias = detalle.value(forKey: "cirugias") as? String{
                    cell.lblCirugias.text = cirugias
                }
                
                
                if let herencias = detalle.value(forKey: "herencias") as? String{
                    cell.lblHerencias.text = herencias
                }
                
                
                if let medicamentos = detalle.value(forKey: "medicamentosSup") as? String{
                    cell.lblMedicamentos.text = medicamentos
                }
                
                if let grupo = detalle.value(forKey: "grupoSanguineo") as? String{
                    cell.lblGrupoSanguineo.text = grupo
                }
                
                if let hospitalizacion = detalle.value(forKey: "hospitalizacion") as? String{
                    cell.lblHospitalizacion.text = hospitalizacion
                }
                
                if let sexualidad = detalle.value(forKey: "sexualidad") as? String{
                    cell.lblSexualmente.text = sexualidad
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                
                
                
                if let ultimo = detalle.value(forKey: "ultimoPapanicolao") as? Date{
                    cell.lblPapanicolao.text = formatter.string(from: ultimo)
                }
                
                var fumtipononulo = ""
                               if let fumtipo = detalle.value(forKey: "fumtipo") as? String{
                                   fumtipononulo = fumtipo
                               }
                
                if let fum = detalle.value(forKey: "fum") as? Date{
                    cell.lblFUM.text = formatter.string(from: fum) + " " + fumtipononulo
                }
                
                
            }
            catch {
                print (error)
            }
            
            
            
            return cell
            
        }
        
    }
    
    
    
    func getTutor(success:@escaping (PFUser) -> (),errorCode: @escaping (Int) -> (),objectId: String){
        
        let query = PFUser.query()!
        query.whereKey("objectId", equalTo: objectId)
        query.getFirstObjectInBackground { (tutor, error) in
            if(error == nil){
                
                if let user = tutor{
                    print("HAAAAAAY TUTOR")
                    success(user as! PFUser)
                }else{
                    print("HAAAAAAY NOOOOO TUTOR")
                    errorCode(-400)
                }
            }else{
                
                errorCode(-400)
            }
        }
        
    }
    
    func getCita(success:@escaping (PFObject) -> (),errorCode: @escaping (Int) -> (),patient: PFObject){
        
        let query = PFQuery(className: "Appointment")
        query.order(byAscending: "date")
        query.includeKey("patient.tutor")
        query.whereKey("date", greaterThanOrEqualTo: self.yesterday())
        query.whereKey("patient", equalTo: patient)
        query.getFirstObjectInBackground { (appointment, error) in
            if(error == nil){
                
                if let user = appointment{
                    print("HAAAAAY CITA")
                    success(user)
                }else{
                    print("HAAAAAY noooo CITA")
                    errorCode(-400)
                }
            }else{
                print("HAAAAAY noooo CITA 2")
                errorCode(-400)
            }
        }
        
    }
    
    
    func yesterday() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(-1, for: .day) // -1 day
        
        let now = Date() // Current date
        let yesterday = Calendar.current.date(byAdding: dateComponents, to: now) // Add the DateComponents
        
        return yesterday!
    }
    
    func getTodayString(date: Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM"
        //formatter.timeStyle = .long
        // formatter.amSymbol = "AM"
        //formatter.pmSymbol = "PM"
        let currentDateStr = formatter.string(from: date)
        print(currentDateStr)
        return currentDateStr
    }
    
}
