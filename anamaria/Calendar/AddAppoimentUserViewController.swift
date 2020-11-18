//
//  AddAppoimentUserViewController.swift
//  anamaria
//
//  Created by ArturoGR on 09/12/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit
import Parse

class AddAppoimentUserViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblToday: UILabel!
    
    @IBOutlet weak var pickHour: UIPickerView!
    var delegateCalendar : NewAppoimentCalendar?
    
    @IBAction func closeAdd(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    var hrIni = ""
    var hrFin = ""
    var todayStr = ""
    
    var genDate :Date!
    
    let cale = Calendar.current
    var components : DateComponents!
    var pati : PFUser!
    
    var monthsStr = ["Enero", "Febrero", "Marzo","Abril", "Mayo", "Junio","Julio", "Agosto", "Septiembre","Octubre", "Noviembre", "Diciembre"]
    
    let weekDays = ["Domingo","Lunes","Martes",
                    "Miércoles","Jueves","Viernes","Sábado"]
    
    let hourss = ["08:00","09:00","10:00",
                  "11:00","12:00","13:00","14:00","15:00","16:00","17:00",
                  "18:00","19:00","20:00"]
    
    let hourssHalf = ["08:30","09:30","10:30",
                      "11:30","12:30","13:30","14:30","15:30","16:30","17:30",
                      "18:30","19:30","20:30"]
    
    //@IBOutlet weak var patientPicker: UIPickerView!
    
    @IBOutlet weak var halfHourSeg: UISegmentedControl!
    //©Appointment
    @IBAction func saveAppoitment(_ sender: Any) {
        
        let cita = PFObject(className: "Appointment")
        cita.setValue(hrIni, forKey: "horaInicio")
        cita.setValue(hrFin, forKey: "horaFin")
        let fechaCita = Calendar.current.startOfDay(for: self.genDate)
        cita.setValue(fechaCita, forKey: "date")
        // agregar
        //cita.setValue(PFUser.current(), forKey:"user")
        cita.setValue(PFUser.current(), forKey: "patient")
        
        if let user  = PFUser.current()?.value(forKey: "nutritionist") as? PFUser{
            cita.setValue(user, forKey:"user")
        }
        
        
        cita.saveInBackground { (success, error) in
            if(success){
                self.dismiss(animated: true, completion: nil)
            }else{
                self.createAlert(title: "Atención!", message: "No se guardo la cita correctamente")
            }
        }
    }
    
    @IBAction func setHour(_ sender: Any) {
        let hr = self.halfHourSeg.selectedSegmentIndex
        
        switch hr {
            
        case 0:
            self.lblToday.text = "\(todayStr) Inicia: \(hourss[self.pickHour.selectedRow(inComponent: 0)])  Termina \(hourssHalf[self.pickHour.selectedRow(inComponent: 0)])"
            self.hrIni = "\(hourss[self.pickHour.selectedRow(inComponent: 0)])"
            self.hrFin = "\(hourssHalf[self.pickHour.selectedRow(inComponent: 0)])"
            
            print("esto quiero? \(self.pickHour.selectedRow(inComponent: 0))")
            print("%%% \(self.hourss[self.pickHour.selectedRow(inComponent: 0)])")
            
            
        case 1:
            if(self.pickHour.selectedRow(inComponent: 0) == 12){
                self.lblToday.text = "\(todayStr) Inicia: \(hourss[self.pickHour.selectedRow(inComponent: 0)])  Termina 21:00"
                self.hrIni = "\(hourss[self.pickHour.selectedRow(inComponent: 0)])"
                self.hrFin = "21:00"
            }else{
                self.lblToday.text = "\(todayStr) Inicia: \(hourss[self.pickHour.selectedRow(inComponent: 0)])  Termina \(hourss[self.pickHour.selectedRow(inComponent: 0) + 1])"
                self.hrIni = "\(hourss[self.pickHour.selectedRow(inComponent: 0)])"
                self.hrFin = "\(hourss[self.pickHour.selectedRow(inComponent: 0) + 1])"
            }
            
        default:
            self.lblToday.text = "\(todayStr) Inicia: \(hourss[self.pickHour.selectedRow(inComponent: 0)])  Termina \(hourssHalf[self.pickHour.selectedRow(inComponent: 0)])"
            self.hrIni = "\(hourss[self.pickHour.selectedRow(inComponent: 0)])"
            self.hrFin = "\(hourssHalf[self.pickHour.selectedRow(inComponent: 0)])"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickHour.dataSource = self
        pickHour.delegate = self
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddAppoimentViewController.dissmisKeyboard))
        view.addGestureRecognizer(tap)
        
        self.setBtnStyle(view: self.btnSave)
        
        self.components = cale.dateComponents([.year, .month, .day,.weekday,.hour, .minute], from: self.genDate)
        
        let weekDay = weekDays[components.weekday! - 1]
        
        
        self.todayStr = "\(String(describing: weekDay)) \(String(describing: components.day!)) de \(String(describing: monthsStr[components.month! - 1]))"
        
        self.lblToday.text = "\(todayStr) Inicia: \(hourss[self.pickHour.selectedRow(inComponent: 0)])  Termina \(hourssHalf[self.pickHour.selectedRow(inComponent: 0)])"
        self.hrIni = "\(hourss[self.pickHour.selectedRow(inComponent: 0)])"
        self.hrFin = "\(hourssHalf[self.pickHour.selectedRow(inComponent: 0)])"
        
        print("esto quiero? \(self.pickHour.selectedRow(inComponent: 0))")
        print("%%% \(self.hourss[self.pickHour.selectedRow(inComponent: 0)])")
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hourss.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hourss[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print(row)
        if(self.halfHourSeg.selectedSegmentIndex == 0){
            
            self.lblToday.text = "\(todayStr) Inicia: \(hourss[row])  Termina \(hourssHalf[row])"
            self.hrIni = "\(hourss[row])"
            self.hrFin = "\(hourssHalf[row])"
        }else{
            
            if(row == 12){
                self.lblToday.text = "\(todayStr) Inicia: \(hourss[row])  Termina 21:00"
                self.hrIni = "\(hourss[row])"
                self.hrFin = "21:00"
            }else{
                self.lblToday.text = "\(todayStr) Inicia: \(hourss[row])  Termina \(hourss[row + 1])"
                self.hrIni = "\(hourss[row])"
                self.hrFin = "\(hourss[row + 1])"
                
            }
        }
        //}
    }
    
    
}
