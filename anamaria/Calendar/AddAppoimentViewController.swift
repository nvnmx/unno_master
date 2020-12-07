//
//  AddAppoimentViewController.swift
//  anamaria
//
//  Created by Francisco Constante on 1/29/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit
import Parse


protocol AddAppointmentViewControllerProtocol {
    func dismissactualizarPacientes()
}

class AddAppoimentViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var paciente : PFUser!
    
    var calendariosList = [PFObject] ()
    var citas:[PFObject] = []
    
    ////New
    struct Objects {
        var name : String
        var patients = [PFObject]()
    }
    
    var pacienteSelect = ""
    var patientsGroup = [Objects] ()
    var patients = [Objects] ()
    
    @IBOutlet weak var patientsTable: UITableView!
    @IBOutlet weak var patiensSearch: UISearchBar!
    
    var searchActive : Bool = false
    ///
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblToday: UILabel!
    @IBOutlet var viewGeneral: UIView!
    @IBOutlet weak var pickHour: UIPickerView!
    var delegateCalendar : NewAppoimentCalendar?
    var delegate : AddAppointmentViewControllerProtocol!
    
    @IBAction func closeAdd(_ sender: Any) {
        if let delegate = delegateCalendar{
            // delegate.newAppoiment()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        if let delegate = delegateCalendar{
            //delegate.newAppoiment()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //var patients:[PFObject] = []
    var patientsStr:[String] = []
    
    var hrIni = ""
    var hrFin = ""
    var todayStr = ""
    
    var genDate :Date!
    
    let cale = Calendar.current
    var components : DateComponents!
    
    
    var monthsStr = ["Enero", "Febrero", "Marzo","Abril", "Mayo", "Junio","Julio", "Agosto", "Septiembre","Octubre", "Noviembre", "Diciembre"]
    
    let weekDays = ["Domingo","Lunes","Martes",
                    "Miércoles","Jueves","Viernes","Sábado"]
    
    var hourss = [String]()
    
    var horariosInicio = [Double]()
    var horariosFin = [Double]()
    
    //@IBOutlet weak var patientPicker: UIPickerView!
    
    @IBOutlet weak var halfHourSeg: UISegmentedControl!
    //©Appointment
    @IBAction func saveAppoitment(_ sender: Any) {
        
        let cita = PFObject(className: "Appointment")
        cita.setValue(hrIni, forKey: "horaInicio")
        cita.setValue(hrFin, forKey: "horaFin")
        let fechaCita = Calendar.current.startOfDay(for: self.genDate)
        cita.setValue(fechaStartDay(date: fechaCita), forKey: "date")
        cita.setValue(PFUser.current(), forKey:"user")
        let fechaHoy = Date()
        let toDay = Calendar.current.startOfDay(for: fechaHoy)
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
        
        
        if(self.paciente != nil){
            cita.setValue(self.paciente, forKey: "patient")
        }else{
            self.createAlert(title: "Alerta", message: "Seleccione un paciente para la cita")
            return
        }
        
        
        cita.saveInBackground { (success, error) in
            if(success){
                
                self.dismiss(animated: true, completion: nil)
                self.delegate!.dismissactualizarPacientes()
            }else{
                self.createAlert(title: "Error", message: "No se guardó la cita correctamente")
            }
        }
    }
    
    @IBAction func setHour(_ sender: Any) {
        
        llenarHorariosDisponibles()
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddAppoimentViewController.dissmisKeyboard))
        view.addGestureRecognizer(tap)
        
        //patientPicker.dataSource = self
        //patientPicker.delegate = self
        
        pickHour.dataSource = self
        pickHour.delegate = self
        
        self.popupView.layer.cornerRadius = 20
        self.popupView.layer.masksToBounds = true
        
        self.setBtnStyle(view: self.btnSave)
        
        self.components = cale.dateComponents([.year, .month, .day,.weekday,.hour, .minute], from: self.genDate)
        
        bajarHorariosDisponibles()
        
        let weekDay = weekDays[components.weekday! - 1]
        
        //self.lblMonth.text = monthsStr[components.month! - 1]
        
        //\(String(describing: components.hour!)):\(String(describing: components.minute!))
        
        self.todayStr = "\(String(describing: weekDay)) \(String(describing: components.day!)) de \(String(describing: monthsStr[components.month! - 1]))"
        
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
                                    hourss.append(horaInicioS + " — " + horaFinS)
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
                                    hourss.append(horaInicioS + " — " + horaFinS)
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
            self.lblToday.text = "\(todayStr)\n\(hourss[0]) "
            self.hrIni = obtenerHoraString(horario: horariosInicio[0])
            self.hrFin = obtenerHoraString(horario: horariosFin[0])
        }
        else
        {
            
            self.createAlert(title: "Alerta", message: "No hay un horario de consulta para este día. Asígnalo en el apartado de Configuraciones")
            self.dismiss(animated: true, completion: nil)
        }
        
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
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        /* if(pickerView == patientPicker){
         return patientsStr.count
         }else{
         return hourss.count
         }*/
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
        
        
        self.lblToday.text = "\(todayStr)\n\(hourss[row]) "
        self.hrIni = obtenerHoraString(horario: horariosInicio[row])
        self.hrFin = obtenerHoraString(horario: horariosFin[row])
        
    }
    
    
}

extension AddAppoimentViewController : UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getPatients()
    }
    
    
    func getPatients(){
        self.patientsGroup = [Objects]()
        self.patients = [Objects]()
        
        let query_novedades = PFUser.query()!
        query_novedades.order(byAscending: "name")
        query_novedades.whereKey("typeUser", equalTo: "patient")
        query_novedades.whereKey("nutritionist", equalTo: PFUser.current())
        
        query_novedades.findObjectsInBackground { (objects, error) in
            
            if(error == nil ){
                var section: [String] = []
                var auxiliarOrdenar = [PFObject] ()
                
                for pa:PFObject in objects!{
                    if let nombreInicial = pa.value(forKey: "name") as? String{
                        if auxiliarOrdenar.count == 0
                        {
                            auxiliarOrdenar.append(pa)
                        }
                        else
                        {
                            var cont = 0
                            var insertado = false
                            for aux:PFObject in auxiliarOrdenar {
                                if let nombreRecorriendo = aux.value(forKey: "name") as? String{
                                    let resComp = nombreInicial.compare(nombreRecorriendo, options: NSString.CompareOptions.caseInsensitive)
                                    if resComp == .orderedAscending
                                    {
                                        auxiliarOrdenar.insert(pa, at: cont)
                                        insertado = true
                                        break
                                    }
                                    cont = cont + 1
                                }
                            }
                            if !insertado
                            {
                                auxiliarOrdenar.append(pa)
                            }
                        }
                    }
                }
                for pa:PFObject in auxiliarOrdenar{
                    if let name = pa.value(forKey: "name") as? String{
                        let headerChar = "\(name[name.index(name.startIndex, offsetBy: 0)])"
                        if(!section.contains(headerChar)){
                            section.append(headerChar)
                            self.patientsGroup.append(Objects(name: headerChar, patients: self.getSetions(patients: objects!, tittle: headerChar)))
                        }
                    }
                }
                
                self.patients = self.patientsGroup
                self.patientsTable.reloadData()
            }
        }
    }
    
    func getSetions(patients : [PFObject], tittle: String) -> [PFObject] {
        
        var count = 0
        var pac:[PFObject] = [PFObject]()
        
        for paciente in patients{
            count = count + 1
            
            if let header = paciente.value(forKey: "name") as? String{
                let headerChar = "\(header[header.index(header.startIndex, offsetBy: 0)])"
                
                if(headerChar == tittle){
                    pac.append(paciente)
                }
            }
        }
        return pac
    }
    
    func newSetions(patients : [PFObject], tittle: String,filter: String) -> [PFObject] {
        
        var count = 0
        var pac:[PFObject] = [PFObject]()
        
        for paciente in patients{
            count = count + 1
            
            if let header = paciente.value(forKey: "name") as? String{
                let headerChar = "\(header[header.index(header.startIndex, offsetBy: 0)])"
                
                if(headerChar == tittle){
                    if(header.lowercased().contains(filter.lowercased())){
                        pac.append(paciente)
                    }
                }
            }
        }
        return pac
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("ENTRO AL searchText 11 \(searchText)")
        filterContentForSearchText(searchText)
    }
    
    @objc func dissmisKeyboard(){
        view.endEditing(true)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        if(searchText == ""){
            self.patientsGroup = self.patients
        }else{
            print("ENTRO AL searchText \(searchText)")
            var pacNew:[Objects] = [Objects]()
            for paciente in self.patients{
                
                let obj = self.newSetions(patients: paciente.patients , tittle: paciente.name, filter: searchText)
                if(obj.count != 0){
                    pacNew.append(Objects(name: paciente.name, patients: obj))
                }
            }
            
            self.patientsGroup = pacNew
        }
        
        patientsTable.reloadData()
    }
    
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        dissmisKeyboard()
        self.patientsTable.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.patientsGroup.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderNotification.createMyClassView()
        header.lblTitle.text = "\(self.patientsGroup[section].name)_"
        return header
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.patientsGroup[section].name)_"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patientsGroup[section].patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientsCell", for: indexPath) as! PatientsTableViewCell
        
        let nov = self.patientsGroup[indexPath.section].patients[indexPath.row]
        
        if let name = nov.value(forKey: "name") as? String{
            if let last = nov.value(forKey: "lastName") as? String{
                cell.name.text = "\(name) \(last)"
            }
        }
        
        if let isTutor = nov.value(forKey: "isTutor") as? Bool{
            if(isTutor){
                cell.isTutor.isHidden = false
            }else{
                cell.isTutor.isHidden = true
            }
        }else{
            cell.isTutor.isHidden = true
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if(self.pacienteSelect == nov.objectId!){
            cell.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        }else{
            cell.backgroundColor = UIColor.white
        }
        
        cell.onButtonTapped = {
            if let name = nov.value(forKey: "name") as? String{
                print("ENTRO AL PACIENTE \(name)")
            }
            
            self.pacienteSelect = nov.objectId!
            self.paciente = nov as? PFUser
            self.patientsTable.reloadData()
            /* let destination = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
             destination.pacienteUser = (nov as! PFUser)
             self.show(destination, sender: nil)*/
            
        }
        
        return cell
    }
    
}
