//
//  ConsultasViewController.swift
//  anamaria
//
//  Created by ArturoGR on 8/18/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit
import Parse


class ConsultasViewController: UIViewController {
    
    let colorP = UIColor(red:0.44, green:0.31, blue:0.85, alpha:1)
    
    @IBOutlet weak var domingo: UILabel!
    @IBOutlet weak var lunes: UILabel!
    @IBOutlet weak var martes: UILabel!
    @IBOutlet weak var miercoles: UILabel!
    @IBOutlet weak var jueves: UILabel!
    @IBOutlet weak var viernes: UILabel!
    @IBOutlet weak var sabado: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var pickerOne: UIDatePicker!
    @IBOutlet weak var pickerTwo: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    var calendariosList = [PFObject] ()
    
    
    
    var count = 1
    
    let week = ["Do","Lu","Ma",
                "Mi","Ju","Vi","Sa"]
    
    var weekDays: [String] = []
    
    var firstHour = "07:00"
    var lastHour = "08:00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        self.setBtnStyle(view: self.btnSave)
        
        
    }
    
    func setData(){
        
        dataHours(first: "07:00", last: "08:00")
        
        if let user = PFUser.current(){
            
            let query = PFQuery(className:"Schedule")
            //query.whereKey("isRead", equalTo: false)
            
            query.whereKey("userId", equalTo: user)
            query.order(byDescending: "createdAt")
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    // The request failed
                    print(error.localizedDescription)
                } else {
                    self.calendariosList.removeAll()
                    for pa:PFObject in objects!{
                        self.calendariosList.append(pa)
                    }
                    self.tableView.reloadData()
                }
            }
            
            
            
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func dataWeek(weekDays: [String]){
        
        domingo.textColor = UIColor.lightGray
        lunes.textColor = UIColor.lightGray
        martes.textColor = UIColor.lightGray
        miercoles.textColor = UIColor.lightGray
        jueves.textColor = UIColor.lightGray
        viernes.textColor = UIColor.lightGray
        sabado.textColor = UIColor.lightGray
        
        domingo.layer.borderColor = UIColor.clear.cgColor
        lunes.layer.borderColor = UIColor.clear.cgColor
        martes.layer.borderColor = UIColor.clear.cgColor
        miercoles.layer.borderColor = UIColor.clear.cgColor
        jueves.layer.borderColor = UIColor.clear.cgColor
        viernes.layer.borderColor = UIColor.clear.cgColor
        sabado.layer.borderColor = UIColor.clear.cgColor
        
        for day in weekDays{
            
            if(day == "Do"){
                domingo.layer.borderWidth = 2.0
                domingo.layer.borderColor = self.colorP.cgColor
                domingo.layer.cornerRadius = 15.0
                domingo.textColor = UIColor.black
            }
            
            if(day == "Lu"){
                lunes.layer.borderWidth = 2.0
                lunes.layer.borderColor = self.colorP.cgColor
                lunes.layer.cornerRadius = 15.0
                lunes.textColor = UIColor.black
            }
            
            if(day == "Ma"){
                martes.layer.borderWidth = 2.0
                martes.layer.borderColor = self.colorP.cgColor
                martes.layer.cornerRadius = 15.0
                martes.textColor = UIColor.black
            }
            
            if(day == "Mi"){
                miercoles.layer.borderWidth = 2.0
                miercoles.layer.borderColor = self.colorP.cgColor
                miercoles.layer.cornerRadius = 15.0
                miercoles.textColor = UIColor.black
            }
            
            if(day == "Ju"){
                jueves.layer.borderWidth = 2.0
                jueves.layer.borderColor = self.colorP.cgColor
                jueves.layer.cornerRadius = 15.0
                jueves.textColor = UIColor.black
            }
            
            if(day == "Vi"){
                viernes.layer.borderWidth = 2.0
                viernes.layer.borderColor = self.colorP.cgColor
                viernes.layer.cornerRadius = 15.0
                viernes.textColor = UIColor.black
            }
            
            if(day == "Sa"){
                sabado.layer.borderWidth = 2.0
                sabado.layer.borderColor = self.colorP.cgColor
                sabado.layer.cornerRadius = 15.0
                sabado.textColor = UIColor.black
            }
            
        }
    }
    
    func dataHours(first: String, last: String){
        
        let hourOne = first.components(separatedBy: ":")
        let hourTwo = last.components(separatedBy: ":")
        
        print("Hora \(hourOne)")
        print("Hora \(hourTwo)")
        
        let calendar = NSCalendar.current
        let components = NSDateComponents()
        components.hour = Int(hourOne[0]) ?? 00
        components.minute = Int(hourOne[1]) ?? 00
        self.pickerOne.setDate(calendar.date(from: components as DateComponents)!, animated: false)
        
        
        let calendarTwo = NSCalendar.current
        let componentsTwo = NSDateComponents()
        componentsTwo.hour = Int(hourTwo[0]) ?? 00
        componentsTwo.minute = Int(hourTwo[1]) ?? 00
        self.pickerTwo.setDate(calendarTwo.date(from: componentsTwo as DateComponents)!, animated: false)
        
    }
    
    
    @IBAction func save(_ sender: Any) {
        
       
        
        var seEmpalma = false
        
        var estanAlReves = false
        
        if self.weekDays.count > 0
        {
            
            for horario:PFObject in self.calendariosList{
                if let weekdays = horario.object(forKey: "weekDays") as? [String]{
                    
                    for diaC:String in weekdays{
                        
                        for diaN:String in self.weekDays{
                            
                            
                            // quiere decir que tenemos que evaluar los horarios
                            let horarioIniC = horario.object(forKey: "firstHour") as? String
                            
                            let horarioFinC = horario.object(forKey: "lastHour") as? String
                            
                            let start = horarioIniC!.index(horarioIniC!.startIndex, offsetBy: 0)
                            let end = horarioIniC!.index(horarioIniC!.endIndex, offsetBy: -3)
                            let range = start..<end
                            
                            let startM = horarioIniC!.index(horarioIniC!.startIndex, offsetBy: 3)
                            let endM = horarioIniC!.index(horarioIniC!.endIndex, offsetBy: 0)
                            let rangeM = startM..<endM
                            
                            let horaInicioHrC = horarioIniC![range]
                            
                            let horaFinHrC = horarioFinC![range]
                            
                            let horaInicioMinC = horarioIniC![rangeM]
                            
                            let horaFinMinC = horarioFinC![rangeM]
                            
                            
                            let horaInicioHrN = self.firstHour[range]
                            
                            let horaFinHrN = self.lastHour[range]
                            
                            let horaInicioMinN = self.firstHour[rangeM]
                            
                            let horaFinMinN = self.lastHour[rangeM]
                            
                            
                            
                            var horaInicioCV = Double(horaInicioHrC)
                            if horaInicioMinC == "30"
                            {
                                horaInicioCV = horaInicioCV! + 0.5
                            }
                            
                            var horaFinCV = Double(horaFinHrC)
                            
                            if horaFinMinC == "30"
                            {
                                horaFinCV = horaFinCV! + 0.5
                            }
                            
                            var horaInicioNV = Double(horaInicioHrN)
                        
                            if horaInicioMinN == "30"
                            {
                                horaInicioNV = horaInicioNV! + 0.5
                            }
                            
                            var horaFinNV = Double(horaFinHrN)
                            if horaFinMinN == "30"
                            {
                                horaFinNV = horaFinNV! + 0.5
                            }
                            
                            if horaInicioNV! >= horaFinNV!
                            {
                                estanAlReves = true
                            }
                            
                            if diaN == diaC
                            {
                                
                                if horaInicioNV! < horaInicioCV! && horaFinNV! > horaFinCV!
                                {
                                    seEmpalma = true
                                }
                                
                                if horaInicioNV! == horaInicioCV! && horaInicioNV! < horaFinCV!
                                {
                                    seEmpalma = true
                                }
                                
                                if horaInicioNV! == horaInicioCV! && horaInicioNV! == horaFinCV!
                                {
                                    seEmpalma = true
                                }
                                
                                
                                if horaInicioNV! < horaInicioCV! && horaFinNV! > horaInicioCV! && horaFinNV! <= horaFinCV!
                                {
                                    seEmpalma = true
                                }
                                
                                if horaInicioNV! >= horaInicioCV! && horaInicioNV! < horaFinCV! && horaFinNV! > horaFinCV!
                                {
                                    seEmpalma = true
                                }
                                
                                if horaFinNV! == horaFinCV! && horaInicioNV! < horaFinCV! && horaInicioNV! > horaInicioCV!
                                {
                                    seEmpalma = true
                                }
                                
                            }
                            
                        }
                    }
                }
                
            }
            
            if seEmpalma
            {
                self.createAlert(title: "Error", message: "El horario ya está incluído en otro anterior. Por favor verifique")
            }
            else
            {
                
                if estanAlReves
                {
                    self.createAlert(title: "Error", message: "El horario inicial no puede ser mayor o igual al final. Por favor verifique")
                }
                else
                {
                    
                    
                    if let user = PFUser.current(){
                        let bal = PFObject(className: "Schedule")
                        bal.setValue(self.weekDays, forKey: "weekDays")
                        bal.setValue(self.firstHour, forKey: "firstHour")
                        bal.setValue(self.lastHour, forKey: "lastHour")
                        bal.setValue(user, forKey: "userId")
                        
                        
                        bal.saveInBackground { (success, error) in
                            if(success){
                                
                                self.setData()
                            }else{
                                self.createAlert(title: "Alerta", message: "No se guardó el horario correctamente")
                            }
                        }
                    }
                }
            }
        }
        else
        {
            self.createAlert(title: "Alerta", message: "Seleccione algún día")
        }
        
    }
    
    @IBAction func btn0(_ sender: Any) {
        self.selectWeek(day: week[0])
    }
    
    @IBAction func btn1(_ sender: Any) {
        self.selectWeek(day: week[1])
    }
    
    @IBAction func btn2(_ sender: Any) {
        self.selectWeek(day: week[2])
    }
    
    @IBAction func btn3(_ sender: Any) {
        self.selectWeek(day: week[3])
    }
    
    @IBAction func btn4(_ sender: Any) {
        self.selectWeek(day: week[4])
    }
    
    @IBAction func btn5(_ sender: Any) {
        self.selectWeek(day: week[5])
    }
    
    @IBAction func btn6(_ sender: Any) {
        self.selectWeek(day: week[6])
    }
    
    func selectWeek(day: String){
        
        if(self.weekDays.contains(day)){
            if let index = self.weekDays.firstIndex(of: day) {
                self.weekDays.remove(at: index)
            }
        }else{
            self.weekDays.append(day)
        }
        self.dataWeek(weekDays: self.weekDays)
    }
    
    
    @IBAction func checkPicker(_ sender: UIDatePicker) {
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY HH:mm"
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "EEE, dd MMM yyyy HH:mm"
        
        if(sender == pickerOne){
            self.firstHour = self.getTodayString(date: sender.date)
        }else{
            self.lastHour = self.getTodayString(date: sender.date)
        }
        
        print("Hora :: \(self.getTodayString(date: sender.date)))  ")
        
    }
    
    func getTodayString(date: Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        //formatter.timeStyle = .long
        // formatter.amSymbol = "AM"
        //formatter.pmSymbol = "PM"
        let currentDateStr = formatter.string(from: date)
        print(currentDateStr)
        return currentDateStr
    }
}



extension ConsultasViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return  true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let calen = self.calendariosList[ indexPath.row]
            
            
            let bal = PFObject(className: "Schedule")
            bal.setValue(calen.objectId, forKey: "objectId")
            
            
            
            bal.deleteInBackground { (success, error) in
                if(success){
                    self.setData()
                    
                }else{
                    self.createAlert(title: "Alerta", message: "No se pudo borrar el horario")
                }
            }
            
            
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendariosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CalendarViewCell", owner: self, options: nil)?.first as! CalendarViewCell
        let noti = self.calendariosList[indexPath.row]
        
        var horarioCompleto=""
        let horaIni = noti.object(forKey: "firstHour") as? String
        
        let horaFin = noti.object(forKey: "lastHour") as? String
        
        horarioCompleto = horaIni! + " — " + horaFin!
        
        cell.lblHorario.text = horarioCompleto
        
        var dias = ""
        
        if let weekdays = noti.object(forKey: "weekDays") as? [String]{
            
            for pa:String in weekdays{
                dias += " " + pa
            }
        }
        
        cell.lblDias.text = dias
        
        return cell
    }
    
    
    
    
    
    
    
}
