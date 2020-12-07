//
//  ReSheduleViewController.swift
//  anamaria
//
//  Created by ArturoGR on 8/18/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit
import Parse
import FSCalendar


  protocol SheduleViewControllerProtocol {
    func actualizarCitas()
}

class SheduleViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
   
    
    var delegate : SheduleViewControllerProtocol!
    var calendariosList = [PFObject] ()
     var paciente = String ()
       var citas:[PFObject] = []
    
    var hourss = [String]()
     var days = 1
       
      var horariosInicio = [Double]()
       var horariosFin = [Double]()
 
    
    @IBOutlet weak var halfHourSeg: UISegmentedControl!
    
    let colorP = UIColor(red:0.44, green:0.31, blue:0.85, alpha:1)
    var shedule : PFObject?
    var horarioSelect = ""
    var indexSelect = -1
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblToday: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
      @IBOutlet weak var pickHour: UIPickerView!
     var componentsGeneral: [Int] = []
    var firstHour = "00:00"
    var lastHour = "00:00"
    
    
       var hrIni = ""
       var hrFin = ""
    
    var firstHourUser = "00:00"
    var lastHourUser = "00:00"
    
 
    
    var monthsStr = ["Enero", "Febrero", "Marzo","Abril","Mayo","Junio","Julio","Agosto", "Septiembre","Octubre","Noviembre", "Diciembre"]
    
    let weekDays = ["Domingo","Lunes","Martes",
                    "Miércoles","Jueves","Viernes","Sábado"]
    
     var week: [String] = []
    
    let selectDay = ""
    
    var genDate = Date()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCalendar()
        btnSave.layer.borderWidth = 2.0
        btnSave.layer.borderColor = self.colorP.cgColor
        btnSave.layer.cornerRadius = 25.0
        
       pickHour.dataSource = self
            pickHour.delegate = self
               let cale = Calendar.current
        let components = cale.dateComponents([.year, .month, .day,.weekday], from: self.genDate)
               let componentesDiaHoy = cale.dateComponents([.year, .month, .day,.weekday], from: Date())
        if(components == componentesDiaHoy){
            self.obtenerCitas(isFilter: false, dateInicio: self.genDate, componets: self.componentsGeneral)
        }else{
          
           self.obtenerCitas(isFilter: true, dateInicio: self.genDate, componets: self.componentsGeneral)
        }
        
        if(getTypeUser())
        {
            halfHourSeg.isHidden = true
        }
        else
        {
            halfHourSeg.isHidden = false
        }
      
        
     
    }
    
    func setUpCalendar(){
        
        if let inicio = self.shedule?.object(forKey: "horaInicio") as? String{
            self.firstHour = inicio
        }
        
        if let fin = self.shedule?.object(forKey: "horaFin") as? String{
            self.lastHour = fin
        }
        calendar.locale = NSLocale(localeIdentifier: "es_MX") as Locale
        
        calendar.select(Date())
        calendar.dataSource = self
        calendar.delegate = self
        
        
        calendar.calendarHeaderView.isHidden = true
        
        let date = Date()
        let cale = Calendar.current
        let components = cale.dateComponents([.year, .month, .day,.weekday], from: date)
        let weekDay = weekDays[components.weekday! - 1]
        let day = components.day
        self.horarioSelect = " \(String(describing: weekDay)) \(String(describing: day!)) "
        self.lblToday.text = horarioSelect
        self.lblMonth.text = "\(monthsStr[components.month! - 1].uppercased()) \(components.year!)"
      
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hourss.count
     }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           
           /*if(pickerView == patientPicker){
            return patientsStr[row]
            }else{
            return hourss[row]
            }*/
           return hourss[row]
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           
          
             
              self.hrIni = obtenerHoraString(horario: horariosInicio[row])
               self.hrFin = obtenerHoraString(horario: horariosFin[row])
           
       }
    
    
    
    @IBAction func cambiaTipo(_ sender: Any) {
        llenarHorariosDisponibles()
    }
    
    func llenarHorariosDisponibles()
       {
           self.hourss.removeAll()
           self.horariosInicio.removeAll()
           self.horariosFin.removeAll()
           let dia = obtenerDiaLetras()
           let tipoCita = self.halfHourSeg.selectedSegmentIndex
           for horario:PFObject in self.calendariosList{
               if let weekdays = horario.object(forKey: "weekDays") as? [String]{
                   
                   for diaC:String in weekdays{
                       
                       if dia == diaC
                       {
                           let horaIni = horario.object(forKey: "firstHour") as? String
                           
                           let horaFin = horario.object(forKey: "lastHour") as? String
                           let horaInicioHorario = obtenerHoraNumero(horario: horaIni!)
                           
                           let horaFinHorario = obtenerHoraNumero(horario: horaFin!)
                           
                           if tipoCita == 0
                           {
                               
                               // vamos a meter todos los horarios en media hr
                               
                               for i in stride(from: horaInicioHorario, through: horaFinHorario - 0.5, by: 0.5) {
                                   var estaLibre = true
                                   
                                   for horario:PFObject in self.citas{
                                       let horaIniCita = horario.object(forKey: "horaInicio") as? String
                                       
                                       let horaFinCita = horario.object(forKey: "horaFin") as? String
                                       let horaIniCitaN = obtenerHoraNumero(horario: horaIniCita!)
                                       
                                       let horaFinCitaN = obtenerHoraNumero(horario: horaFinCita!)
                                       
                                       // si la cita empieza a la misma hora ya no esta libre
                                       if i == horaIniCitaN
                                       {
                                           estaLibre = false
                                           break
                                       }
                                       
                                       //si terminan a la misma hora no esta libre
                                       if horaFinCitaN == i + 0.5
                                       {
                                           estaLibre = false
                                           break
                                       }
                                       
                                   }
                                   
                                   if estaLibre
                                   {
                                       let horaInicioS = obtenerHoraString(horario: i)
                                       let horaFinS = obtenerHoraString(horario: i + 0.5)
                                       hourss.append(horaInicioS + " - " + horaFinS)
                                       horariosInicio.append(i)
                                       horariosFin.append(i+0.5)
                                   }
                                   
                               }
                               
                               
                           }
                           else
                           {
                               // vamos por todos los horarios de una hr
                               
                               for i in stride(from: horaInicioHorario, through: horaFinHorario - 1, by: 0.5) {
                                   var estaLibre = true
                                   
                                   for horario:PFObject in self.citas{
                                       let horaIniCita = horario.object(forKey: "horaInicio") as? String
                                       
                                       let horaFinCita = horario.object(forKey: "horaFin") as? String
                                       let horaIniCitaN = obtenerHoraNumero(horario: horaIniCita!)
                                       
                                       let horaFinCitaN = obtenerHoraNumero(horario: horaFinCita!)
                                       
                                       // si la cita empieza a la misma hora ya no esta libre
                                       if i == horaIniCitaN
                                       {
                                           estaLibre = false
                                           break
                                       }
                                       
                                       //si terminan a la misma hora no esta libre
                                       if horaFinCitaN == i + 0.5
                                       {
                                           estaLibre = false
                                           break
                                       }
                                       
                                       // si el inicio esta dentro del la cita no esta libre
                                       
                                       if i > horaIniCitaN && i < horaFinCitaN
                                       {
                                           estaLibre = false
                                           break
                                       }
                                       
                                       // si el fin esta dentro del la cita no esta libre
                                       
                                       if i + 1  > horaIniCitaN && i + 1 < horaFinCitaN
                                       {
                                           estaLibre = false
                                           break
                                       }
                                       
                                   }
                                   
                                   if estaLibre
                                   {
                                       let horaInicioS = obtenerHoraString(horario: i)
                                       let horaFinS = obtenerHoraString(horario: i + 1)
                                       hourss.append(horaInicioS + " - " + horaFinS)
                                       horariosInicio.append(i)
                                       horariosFin.append(i+1)
                                   }
                               }
                           }
                       }
                   }
               }
           }
             self.pickHour.reloadAllComponents()
           if hourss.count > 0
           {
        
           self.hrIni = obtenerHoraString(horario: horariosInicio[0])
           self.hrFin = obtenerHoraString(horario: horariosFin[0])
           }
           else
           {
                self.createAlert(title: "Alerta", message: "No hay un horario de consulta para este día. Asígnalo en el apartado de Configuraciones")
           }
           
       }
    
    func obtenerCitas(isFilter: Bool,dateInicio: Date,componets: [Int]){
        self.citas.removeAll()
       
       
        
        let queryApp = PFQuery(className: "Appointment")
        queryApp.order(byAscending: "horaInicio")
        queryApp.includeKey("patient")
        queryApp.whereKey("date", greaterThanOrEqualTo: self.yesterday(newDate: isFilter, dateNew: dateInicio,componets: componets))
        queryApp.whereKey("date", lessThanOrEqualTo: self.tomorrow(newDate: isFilter, dateNew: dateInicio,componets: componets))
        queryApp.cachePolicy = .networkElseCache
        
        //AQUI
        if let user = PFUser.current(){
            if(getTypeUser()){
                queryApp.whereKey("patient", equalTo: user)
             }else{
                queryApp.whereKey("user", equalTo: user)
            }
       }
       
        
        queryApp.findObjectsInBackground { (objects, error) in
          
            
            if(error == nil ){
                for pa:PFObject in objects!{
                    self.citas.append(pa)
                }
                self.bajarHorariosDisponibles()
            }
        }
    }
    
    func yesterday(newDate: Bool,dateNew: Date,componets: [Int]) -> Date {
        var dateComponents = DateComponents()
        dateComponents.setValue(-days, for: .day) // -1 day
        let now = Date() // Current date
        if(newDate){
            //now = Calendar.current.date(bySettingHour: 23, minute: 57, second: 0, of: dateNew)!
            let firstDate = "\(componets[0])-\(componets[1])-\(componets[2])T00:00:00"
            //let lastDate = "\(componets[0])-\(componets[1])-\(componets[2])T11:59:00"
            
            return getDate(dateString: firstDate) ?? Date()
        }else{
            
            let yesterday = Calendar.current.date(byAdding: dateComponents, to: now) // Add the DateComponents
            return yesterday!
            
            
        }
       
    }
    
    
    func tomorrow(newDate: Bool,dateNew: Date,componets: [Int]) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(days, for: .day); // +1 day
        
        let now = Date() // Current date
        if(newDate){
            //now = Calendar.current.date(bySettingHour: 23, minute: 57, second: 0, of: dateNew)!
            let lastDate = "\(componets[0])-\(componets[1])-\(componets[2])T11:59:00"
            return getDate(dateString: lastDate) ?? Date()
        }else{
            let tomorrow = Calendar.current.date(byAdding: dateComponents, to: now)  // Add the DateComponents
            return tomorrow!
        }
        
    }
    
    
    func getDate(dateString: String) -> Date? {
        //"2015-04-01T11:42:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        //dateFormatter.timeZone = TimeZone.current
        //dateFormatter.locale = Locale.current
        return dateFormatter.date(from: dateString) // replace Date String
    }
    
    
    
    func obtenerHoraNumero(horario : String)-> Double
       {
           let start = horario.index(horario.startIndex, offsetBy: 0)
           let end = horario.index(horario.endIndex, offsetBy: -3)
           let range = start..<end
           
           let startM = horario.index(horario.startIndex, offsetBy: 3)
           let endM = horario.index(horario.endIndex, offsetBy: 0)
           let rangeM = startM..<endM
           
           let horaInicioHrC = horario[range]
           
           let horaInicioMinC = horario[rangeM]
           var horaInicioCV = Double(horaInicioHrC)
           if horaInicioMinC == "30"
           {
               horaInicioCV = horaInicioCV! + 0.5
           }
           return horaInicioCV!
       }
       
       func obtenerHoraString (horario : Double)-> String
       {
           var minutos = "00"
           if (horario - floor(horario) > 0.1) {
               // quiere decir que es media hora
               minutos = "30"
           }
           var horarioS = String (horario)
            horarioS = horarioS.replacingOccurrences(of: ".5", with: "", options: .literal, range: nil)
            horarioS = horarioS.replacingOccurrences(of: ".0", with: "", options: .literal, range: nil)
           if horario < 10
           {
               horarioS = "0" + horarioS
           }
           
           return horarioS + ":" + minutos
       }
       
       func obtenerDiaLetras()->String
       {
        let date = self.genDate
        let cale = Calendar.current
        let components = cale.dateComponents([.year, .month, .day,.weekday], from: date)
           let weekDay = weekDays[components.weekday! - 1]
           
           if weekDay == "Lunes"
           {
               return "Lu"
           }
           if weekDay == "Domingo"
           {
               return "Do"
           }
           if weekDay == "Martes"
           {
               return "Ma"
           }
           if weekDay == "Miércoles"
           {
               return "Mi"
           }
           if weekDay == "Jueves"
           {
               return "Ju"
           }
           if weekDay == "Viernes"
           {
               return "Vi"
           }
           if weekDay == "Sábado"
           {
               return "Sa"
           }
           return ""
       }
       
    func bajarHorariosDisponibles()
    {
        
        if (getTypeUser())
        {
            if let user = PFUser.current(){
                if let nutId = user.value(forKey: "nutritionistId") as? String{
                    
                    let query = PFQuery(className:"_User")
                    
                    query.whereKey("objectId", equalTo: nutId)
                    query.getFirstObjectInBackground { (nutriologo, error) in
                        if(error == nil){
                            
                            let query = PFQuery(className:"Schedule")
                                         //query.whereKey("isRead", equalTo: false)
                                         
                                         query.whereKey("userId", equalTo: nutriologo)
                                         query.order(byAscending:  "firstHour")
                                         query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                                             if let error = error {
                                                 // The request failed
                                                 print(error.localizedDescription)
                                             } else {
                                                 self.calendariosList.removeAll()
                                                 for pa:PFObject in objects!{
                                                     self.calendariosList.append(pa)
                                                 }
                                                 self.llenarHorariosDisponibles()
                                                 
                                             }
                                         }
                            
                        }
                        else
                        {
                            
                        }
                    }
                }
            }
        }
        else
        {
            if let user = PFUser.current(){
                
                let query = PFQuery(className:"Schedule")
                //query.whereKey("isRead", equalTo: false)
                
                query.whereKey("userId", equalTo: user)
                query.order(byAscending:  "firstHour")
                query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                    if let error = error {
                        // The request failed
                        print(error.localizedDescription)
                    } else {
                        self.calendariosList.removeAll()
                        for pa:PFObject in objects!{
                            self.calendariosList.append(pa)
                        }
                        self.llenarHorariosDisponibles()
                        
                    }
                }
                
            }
        }
    }
       

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        
        let fechaHoy = Date()
        let toDay = Calendar.current.startOfDay(for: fechaHoy)
        let fechaCita = Calendar.current.startOfDay(for: self.genDate)
        if fechaCita < toDay
        {
            self.createAlert(title: "Alerta", message: "La fecha seleccionada no puede ser anterior a hoy")
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let hoy = formatter.string(from: Date())
        let fechaSel = formatter.string(from:self.genDate)
        
        if hoy == fechaSel
        {
            let hour = Calendar.current.component(.hour, from: Date())
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let date = dateFormatter.date(from: hrIni)!
            let hourCita = Calendar.current.component(.hour, from: date)
            
            if hourCita <= hour
            {
                self.createAlert(title: "Alerta", message: "La hora seleccionada ya ha pasado")
                return
            }
            
        }
        
        
        if self.hrIni == ""{
            self.createAlert(title: "Alerta", message: "Seleccione un horario")
            return
        }
        
        
        let query_paciente = PFUser.query()!
        
        query_paciente.whereKey("objectId", equalTo: paciente)
        
        
        query_paciente.getFirstObjectInBackground { (object, error) in
            
            
            let cita = PFObject(className: "Appointment")
            cita.setValue(self.hrIni, forKey: "horaInicio")
            cita.setValue(self.hrFin, forKey: "horaFin")
            let fechaCitaN = self.fechaStartDay(date: self.genDate)
            cita.setValue(fechaCitaN, forKey: "date")
            cita.setValue(object, forKey: "patient")
            cita.setValue(PFUser.current(), forKey: "user")
            cita.saveInBackground { (success, error) in
                if(success){
                    self.dismiss(animated: true, completion: nil)
                    self.delegate.actualizarCitas()
                }
                else
                {
                    
                }
                
            }
        }
    }
    
    
    
}

extension SheduleViewController: FSCalendarDataSource, FSCalendarDelegate{
    
    func calendarCurrentPageDidChange(_ cali: FSCalendar) {
        print("me \(cali.currentPage)")
        let date = cali.currentPage
        let cale = Calendar.current
        let components = cale.dateComponents([.year, .month, .day,.weekday], from: date)
        self.lblMonth.text = "\(monthsStr[components.month! - 1]) \(components.year!)"
        let weekDay = weekDays[components.weekday! - 1]
        if(!self.week.contains("\(String(describing: weekDay))")){
            self.createAlert(title: "Alerta", message: "El día seleccionado no está disponible")
        }
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.genDate = date
         let cale = Calendar.current
         let components = cale.dateComponents([.year, .month, .day,.weekday], from: date)
         let componentesDiaHoy = cale.dateComponents([.year, .month, .day,.weekday], from: Date())
         let weekDay = weekDays[components.weekday! - 1]
         let day = components.day
        
         self.lblToday.text = " \(String(describing: weekDay)) \(String(describing: day!)) "
         
         self.componentsGeneral = [components.year!,components.month!,components.day!]
        if(components == componentesDiaHoy){
         self.obtenerCitas(isFilter: false, dateInicio: self.genDate, componets: self.componentsGeneral)
         }else{
           
            self.obtenerCitas(isFilter: true, dateInicio: self.genDate, componets: self.componentsGeneral)
         }
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
}




