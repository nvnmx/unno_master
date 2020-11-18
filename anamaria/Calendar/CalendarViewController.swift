//
//  CalendarViewController.swift
//  anamaria
//
//  Created by Francisco on 12/16/18.
//  Copyright © 2018 nvn. All rights reserved.
//

import UIKit
import FSCalendar
import Parse
import MBProgressHUD


protocol NewAppoimentCalendar: AnyObject {
    func newAppoiment()
}

class CalendarViewController: UIViewController,AddAppointmentViewControllerProtocol,ReSheduleViewControllerProtocol,UserProfileViewControllerProtocol {
    
    
    
    
    
    
    
    @IBOutlet weak var uiviewCalendar: UIView!
    @IBOutlet weak var imgDrop: UIImageView!
    @IBOutlet weak var heightCalendar: NSLayoutConstraint!
    var citas:[PFObject] = []
    @IBOutlet weak var btnBack: UIButton!
    var isBack = false
    var isOpen = false
    var days = 1
    var componentsGeneral: [Int] = []
    
    @IBOutlet weak var showCalendar: UIButton!
    @IBOutlet weak var lblToday: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var tableCalendar: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    var monthsStr = ["Enero", "Febrero", "Marzo","Abril","Mayo","Junio","Julio","Agosto", "Septiembre","Octubre","Noviembre", "Diciembre"]
    
    let weekDays = ["Domingo","Lunes","Martes",
                    "Miércoles","Jueves","Viernes","Sábado"]
    
    var genDate = Date()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
            actualizarInfo()
       
    }
    
    func dismissactualizarPacientes() {
        self.citas = []
        actualizarInfo()
    }
    
    
    func seActualizoCita() {
        actualizarInfo()
    }
    
    func actualizarInfo() {
         
        
        self.getAppoinments( fechaIni: self.genDate, fechaFin: self.genDate )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.heightCalendar.constant = 20
        self.uiviewCalendar.isHidden = true
        
        calendar.locale = NSLocale(localeIdentifier: "es_MX") as Locale
        calendar.select(Date())
        calendar.dataSource = self
        calendar.delegate = self
        
        
        calendar.calendarHeaderView.isHidden = true
        
        if(isBack){
            self.btnBack.isHidden = false
        }
        
        let date = Date()
        let cale = Calendar.current
        let components = cale.dateComponents([.year, .month, .day,.weekday], from: date)
        let weekDay = weekDays[components.weekday! - 1]
        self.lblMonth.text = "\(monthsStr[components.month! - 1]) \(components.year!)".uppercased()
        let day = components.day
        self.lblToday.text = " \(String(describing: weekDay)) \(String(describing: day!)) "
        
        
        
        
    }
    
    @IBAction func searchUser(_ sender: Any) {
        //
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "SearchAppoimentViewController") as! SearchAppoimentViewController
        self.show(destination, sender: nil)
        
    }
    @IBAction func newAppo(_ sender: Any) {
        
        //self.performSegue(withIdentifier: "addPop", sender: nil)
        
        if(getTypeUser()){
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "AddAppoimentUserViewController") as! AddAppoimentUserViewController
            destination.genDate = self.genDate
            destination.delegateCalendar = self
            
            self.show(destination, sender: nil)
        }else{
            let popVc : AddAppoimentViewController = self.storyboard!.instantiateViewController(withIdentifier: "addPop") as! AddAppoimentViewController
            popVc.citas = self.citas
            popVc.genDate = self.genDate
            popVc.delegate = self
            
            self.present(popVc, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPop"
        {
            let segueController  = segue.destination as! AddAppoimentViewController
            segueController.genDate = self.genDate
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickCalendar(_ sender: Any) {
        
        if(isOpen){
            isOpen = false
            self.heightCalendar.constant = 20
            self.uiviewCalendar.isHidden = true
        }else{
            isOpen = true
            self.heightCalendar.constant = 270
            self.uiviewCalendar.isHidden = false
        }
        
        
        
    }
}


extension CalendarViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    
    func getAppoinments(fechaIni: Date,fechaFin: Date?){
        self.citas.removeAll()
         print("inicio \(fechaIni)")
        print("ENTROCITAS \(self.citas)")
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.mode = MBProgressHUDMode.indeterminate
        
    
        let queryApp = PFQuery(className: "Appointment")
        queryApp.order(byAscending: "horaInicio")
        queryApp.includeKey("patient")
        let fechaIniStart = fechaStartDay(date: fechaIni)
        print("inistsrt \(fechaIniStart)")
        queryApp.whereKey("date", greaterThanOrEqualTo: fechaIniStart)
        if fechaFin != nil
        {
            let conUnDiaMas = Calendar.current.date(byAdding: .day, value: 1, to: fechaFin!)
            let fechaFinStart = fechaStartDay(date: conUnDiaMas!)
             print("finstart \(fechaFinStart)")
            queryApp.whereKey("date", lessThan: fechaFinStart)
        }
        
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
            loader.hide(animated: true)
            
            if(error == nil ){
                for pa:PFObject in objects!{
                    self.citas.append(pa)
                }
                
                self.tableCalendar.reloadData()
            }
        }
    }
    
    
   
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            // Call edit action
            self.citas[indexPath.row].deleteInBackground(block: { (success, error) in
                
                print("ENTRO A BORRAR")
                self.getAppoinments( fechaIni: self.genDate, fechaFin: self.genDate )
                
                
            })
            
            // Reset state
            success(true)
        })
        deleteAction.image = UIImage(named: "deletewhite")
        deleteAction.backgroundColor = UIColor(red: 0.92, green: 0.28, blue: 0.41, alpha: 1.00)
        
        let schedule = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            // Call edit action
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "ReSheduleViewController") as! ReSheduleViewController
            destination.shedule = self.citas[indexPath.row]
            destination.delegate = self
            self.show(destination, sender: nil)
            // Reset state
            success(true)
        })
        
        let imageD = UIImage(named: "reDatewhite")
        schedule.image = imageD
        schedule.backgroundColor = UIColor(red: 0.73, green: 0.73, blue: 0.76, alpha: 1.00)
        
        return UISwipeActionsConfiguration(actions: [deleteAction,schedule])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.citas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("CalendarAppoViewCell", owner: self, options: nil)?.first as! CalendarAppoViewCell
        
        let ci = self.citas[indexPath.row]
        
        if let pa = ci.value(forKey: "patient") as? PFUser{
            if let name = pa.value(forKey: "name") as? String{
                if let last = pa.value(forKey: "lastName") as? String{
                    cell.lblName.text = "\(name) \(last)"
                }
            }
            
            if let isTutor = pa.value(forKey: "isTutor") as? Bool{
                if(isTutor){
                    cell.isTutor.isHidden = false
                }else{
                    cell.isTutor.isHidden = true
                }
            }else{
                cell.isTutor.isHidden = true
            }
        }
        
        if let inicio = ci.value(forKey: "horaInicio") as? String{
            if let fin = ci.value(forKey: "horaFin") as? String{
                cell.lblHour.text = "\(inicio) — \(fin)"
            }
        }
        
        
        
        cell.onButtonTapped = {
            
            if let user = ci.value(forKey: "patient") as? PFUser{
                
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                destination.pacienteUser = user
                destination.delegateUserProfile = self
                self.show(destination, sender: nil)
                
                
            }
            
        }
        
        
        //cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    
}


extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate{
    
    func calendarCurrentPageDidChange(_ cali: FSCalendar) {
        print("ENTROCALENDAR 1")
        print("me \(cali.currentPage)")
        let date = cali.currentPage
        let cale = Calendar.current
        let components = cale.dateComponents([.year, .month, .day,.weekday], from: date)
        self.lblMonth.text = "\(monthsStr[components.month! - 1]) \(components.year!)".uppercased()
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        print("ENTROCALENDAR 2")
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("Selecciono \(date)")
        print("ENTROCALENDAR 3")
        self.genDate = date
        let cale = Calendar.current
        let components = cale.dateComponents([.year, .month, .day,.weekday], from: date)
       
        let weekDay = weekDays[components.weekday! - 1]
        let day = components.day
        
        self.lblToday.text = " \(String(describing: weekDay)) \(String(describing: day!)) "
        
        self.componentsGeneral = [components.year!,components.month!,components.day!]
        actualizarInfo()
         
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        return 0
    }
    
    
    func yesterday(esHoy: Bool,dateNew: Date,componets: [Int]) -> Date {
        var dateComponents = DateComponents()
        dateComponents.setValue(-days, for: .day) // -1 day
        let now = Date() // Current date
        if(!esHoy){
            //now = Calendar.current.date(bySettingHour: 23, minute: 57, second: 0, of: dateNew)!
            let firstDate = "\(componets[0])-\(componets[1])-\(componets[2])T00:00:00"
            //let lastDate = "\(componets[0])-\(componets[1])-\(componets[2])T11:59:00"
            
            return getDate(dateString: firstDate) ?? Date()
        }else{
            
            let yesterday = Calendar.current.date(byAdding: dateComponents, to: now) // Add the DateComponents
            return yesterday!
            
            
        }
        
    }
    
    
    func tomorrow(esHoy: Bool,dateNew: Date,componets: [Int]) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(days, for: .day); // +1 day
        
        let now = Date() // Current date
        if(!esHoy){
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
    
    
}


extension CalendarViewController: NewAppoimentCalendar{
    
    func newAppoiment() {
       actualizarInfo()
    }
    
    
}


