//
//  ProfileViewController.swift
//  anamaria
//
//  Created by Francisco on 12/16/18.
//  Copyright © 2018 nvn. All rights reserved.
//

import UIKit
import Parse
import SDWebImage
import Fusuma
import MBProgressHUD

class ProfileViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, FusumaDelegate {
    
    
    
    @IBOutlet weak var viewImgProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnSaveProfile: UIButton!
    
    @IBOutlet weak var txtNameProfile: UITextField!
    
    @IBOutlet weak var txtLastProfile: UITextField!
    
    @IBOutlet weak var txtExtProfile: UITextField!
    @IBOutlet weak var txtPhoneProfile: UITextField!
    
    @IBOutlet weak var txtExtOffice: UITextField!
    
    @IBOutlet weak var txtOfficePhone: UITextField!
    
    @IBOutlet weak var txtAgeProfile: UITextField!
    
    @IBOutlet weak var txtNumberDegree: UITextField!
    
    @IBOutlet weak var txtEmailProfile: UITextField!
    
    @IBOutlet weak var txtNacionalidad: UITextField!
    
    @IBOutlet weak var txtActividadLaboral: UITextField!
    
    @IBOutlet weak var txtResidencia: UITextField!
    
    @IBOutlet weak var txtContrasenia: UITextField!
    
    @IBOutlet weak var selEstadoCivil: UIPickerView!
    
    @IBOutlet weak var fechaNacimiento: UIDatePicker!
    
    @IBOutlet weak var viewConstraint: UIView!
    
    
    @IBOutlet weak var viewConstrainthe: NSLayoutConstraint!
    
    
    
    
    
    @IBOutlet weak var viewCedula: UIView!
    @IBOutlet weak var lblCedula: UILabel!
    
    
    var pickerData:[String] = [String]()
    
    var pickerDataV:[String] = [String]()
    
    var idDetallePaciente : String = ""
    
    
    @IBAction func clickBtnSave(_ sender: Any) {
        print("click clickEntro a salvar la info :)")
        validateUserInput()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["viudo/a", "soltero/a","divorciado/a","casado/a"]
        pickerDataV = ["VIUDO", "SOLTERO","DIVORCIADO","CASADO"]
        
        self.selEstadoCivil.delegate = self
        self.selEstadoCivil.dataSource = self
        fetchUserInfo()
        if(getTypeUser()){
            txtNumberDegree.isHidden = true
            lblCedula.isHidden = true
            viewCedula.isHidden = true
        }
        else
        {
            viewConstrainthe.constant = 0
            viewConstraint.isHidden = true
            viewConstraint.layoutIfNeeded()
            
            
        }
        
        
    }
    
    func validateUserInput(){
        print("Entro a salvar la info :)")
        
        self.btnSaveProfile.isEnabled = false
        
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.mode = MBProgressHUDMode.indeterminate
        loader.label.text = "Cargando"
        
        let nameStr = txtNameProfile.text
        let ageStr = txtAgeProfile.text
        let lastStr = txtLastProfile.text
        let mailStr = txtEmailProfile.text
        let phoneStr = txtPhoneProfile.text
        let telOff = txtOfficePhone.text
        let cedula = txtNumberDegree.text
        let password = txtContrasenia.text
        
        
        
        
        if(txtEmailProfile.text! != "" && txtLastProfile.text! != ""){
            if(self.isValidEmail(testStr: txtEmailProfile.text!)){
                let user = PFUser.current()
                if(getTypeUser()){
                    guardarDetalle()
                }
                
                
                var imageFile : PFFileObject!
                user?.setValue(nameStr, forKey: "name")
                user?.setValue(ageStr, forKey: "age")
                user?.setValue(phoneStr, forKey: "phone")
                user?.setValue(telOff, forKey: "telefonoOficina")
                user?.setValue(cedula, forKey: "cedulaProfesional")
                user?.setValue(lastStr, forKey: "lastName")
                // user?.setValue(mailStr, forKey: "username")
                
                if password != nil && password != ""
                {
                    user?.setValue(password, forKey: "password")
                }
                
                if imgProfile.image != nil{
                    let imageData = self.imgProfile.image!.jpegData(compressionQuality: 0.75)
                    imageFile = PFFileObject(name: "photo.png", data: imageData!)
                    user?.setValue(imageFile, forKey: "avatar")
                    
                    user?.saveInBackground(block: { (success, error) in
                        if(success){
                            loader.hide(animated: true)
                            self.btnSaveProfile.isEnabled = true
                            let alert = UIAlertController(title: "¡Listo!", message: "Tus datos han sido guardados correctamente", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: { action in
                                let _ = self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            user?.fetchInBackground()
                            user?.fetchIfNeededInBackground()
                        }else{
                            loader.hide(animated: true)
                            self.btnSaveProfile.isEnabled = true
                            let alert = UIAlertController(title: "Alerta", message: "Hubo un problema al guardar los datos. Por favor intente nuevamente", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: { action in
                                let _ = self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    })
                }
                else
                {
                    loader.hide(animated: true)
                    self.createAlert(title: "Alerta", message: "Agregue una foto al perfil")
                }
            }else{
                loader.hide(animated: true)
                self.createAlert(title: "Alerta", message: "E-mail inválido")
            }
        }else{
            loader.hide(animated: true)
            self.createAlert(title: "Alerta", message: "Ingrese todos los campos")
        }
        
    }
    
    func guardarDetalle ()
    {
        
        let residencia = txtResidencia.text
        let nacionalidad = txtNacionalidad.text
        let actividadLaboral = txtActividadLaboral.text
        var selected = pickerDataV[selEstadoCivil.selectedRow(inComponent: 0)]
        var fechaNAc = fechaNacimiento.date
        
        let deta = PFObject(className: "DetallePaciente")
        deta.setValue(idDetallePaciente, forKey: "objectId")
        deta.setValue(fechaNAc, forKey: "fechaNacimiento")
        deta.setValue(selected, forKey: "estadoCivil")
        deta.setValue(actividadLaboral, forKey: "actividadLaboral")
        deta.setValue(residencia, forKey: "residencia")
        deta.setValue(nacionalidad, forKey: "nacionalidad")
        
        
        deta.saveInBackground { (success, error) in
            if(success){
                
            }else{
                
                self.createAlert(title: "Error", message: "No se guardó la información correctamente")
                
            }
        }
    }
    
    func fetchUserInfo(){
        
        self.setBtnTabStyleSelected(view: self.viewImgProfile)
        self.setBtnStyle(view: self.btnSaveProfile)
        
        if let user = PFUser.current(){
            
            if let imageFile = user.object(forKey: "avatar") as? PFFileObject{
                if imageFile.url != nil{
                    if let urlString = imageFile.url{
                        let urlFinal = URL(string: urlString)
                        self.imgProfile.sd_setImage(with: urlFinal)
                        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
                        self.imgProfile.clipsToBounds = true
                    }
                }
            }
            
            
            
            
            user.fetchInBackground()
            if let name = user.value(forKey: "name") as? String{
                txtNameProfile.text = name
            }
            
            
            
            if let last = user.value(forKey: "lastName") as? String{
                txtLastProfile.text = last
            }
            
            if let age = user.value(forKey: "age") as? String{
                txtAgeProfile.text = age
            }
            
            if let telOf = user.value(forKey: "telefonoOficina") as? String{
                txtOfficePhone.text = telOf
            }
            
            if let cedulaProf = user.value(forKey: "cedulaProfesional") as? String{
                txtNumberDegree.text = cedulaProf
            }
            
            if let telefono = user.value(forKey: "phone") as? String{
                txtPhoneProfile.text = telefono
            }
            
            if let email = user.email{
                txtEmailProfile.text = email
            }
            
            fusumaTintColor = UIColor(red:0.89, green:0.26, blue:0.18, alpha:1.0)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.snapShot(_sender:)))
            
            self.viewImgProfile.isUserInteractionEnabled = true
            self.viewImgProfile.addGestureRecognizer(tapGesture)
            
            
            let query = PFQuery(className:"DetallePaciente")
            
            query.whereKey("userId", equalTo: user)
            
            query.getFirstObjectInBackground { (detalle, error) in
                if(error == nil){
                    if let actividadLaboral = detalle?.value(forKey: "actividadLaboral") as? String{
                        self.txtActividadLaboral.text = actividadLaboral
                    }
                    
                    if let nacionalidad = detalle?.value(forKey: "nacionalidad") as? String{
                        self.txtNacionalidad.text = nacionalidad
                    }
                    
                    if let residencia = detalle?.value(forKey: "residencia") as? String{
                        self.txtResidencia.text = residencia
                    }
                    
                    if let fechaNac = detalle?.value(forKey: "fechaNacimiento") as? Date{
                        self.fechaNacimiento.date = fechaNac
                    }
                    
                    if let id = detalle?.value(forKey: "objectId") as? String{
                        self.idDetallePaciente = id
                    }
                    
                    
                    
                    if let estadoCivil = detalle?.value(forKey: "estadoCivil") as? String{
                        
                        
                        
                        if let position = self.pickerDataV.firstIndex(of: estadoCivil){
                            self.selEstadoCivil.selectRow(position, inComponent: 0, animated: true)
                        }
                    }
                    
                    
                }else{
                    
                }
            }
            
            
        }
    }
    
    @objc func snapShot(_sender: UITapGestureRecognizer){
        
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.mode = MBProgressHUDMode.indeterminate
        loader.label.text = "Cargando"
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.present(fusuma, animated: true, completion: nil)
        
        loader.hide(animated: true)
        
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        switch source {
            
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        
        self.imgProfile.image = image
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
        self.imgProfile.clipsToBounds = true
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("video completed and output to file: \(fileURL)")
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Called just after dismissed FusumaViewController using Camera")
        case .library:
            print("Called just after dismissed FusumaViewController using Camera Roll")
        default:
            print("Called just after dismissed FusumaViewController")
        }
        
        self.imgProfile.image = image
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
        self.imgProfile.clipsToBounds = true
    }
    
    func fusumaCameraRollUnauthorized() {
        print("Camera roll unauthorized")
    }
    
    func fusumaClosed() {
        print("Called when the close button is pressed")
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        print ("Updated iOSPODs ")
    }
}
