//
//  FirstViewController.swift
//  anamaria
//
//  Created by Francisco on 1/1/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD


class FirstViewController: UIViewController,UserProfileViewControllerProtocol,ReSheduleViewControllerProtocol {
    
    
    
    
    
    
    
    var delegateMain:MainViewDelegate?
    
    @IBOutlet weak var conteinerDate: UIView!
    @IBOutlet weak var containerDelete: UIView!
    var isRigthCons = false
    @IBOutlet weak var rigthCons: NSLayoutConstraint!
    @IBOutlet weak var rigthConsCard: NSLayoutConstraint!
    @IBOutlet weak var leftConsCard: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgHour: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtAmount: UILabel!
    @IBOutlet weak var txtHour: UILabel!
    @IBOutlet weak var proximaCita: UILabel!
    @IBOutlet weak var sinProximaCita: UILabel!
    
    @IBOutlet weak var txtResume: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    var monthsStr = ["Enero", "Febrero", "Marzo","Abril","Mayo","Junio","Julio","Agosto", "Septiembre","Octubre","Noviembre", "Diciembre"]
    
    let weekDays = ["Domingo","Lunes","Martes",
                    "Miércoles","Jueves","Viernes","Sábado"]
    
    var paciente: PFObject?
    var pacienteUser: PFUser?
    
    @IBAction func seeAllIncome(_ sender: Any) {
        self.delegateMain?.openBalance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // getBalanceWeek()
        self.setCardStyle(view: cardView)
        self.conteinerDate.isHidden = true
        self.containerDelete.isHidden = true
        self.setCardStyleBtn(view: conteinerDate)
        self.setCardStyleBtn(view: containerDelete)
        
        
        
        let date = Date()
        let cale = Calendar.current
        
        let components = cale.dateComponents([.year, .month, .day,.weekday], from: date)
        
        
        
        let day = cale.component(.day, from: date)
        self.txtDate.text = "Hoy \(day) de \(String(describing: self.monthsStr[components.month! - 1]))"
        
        //cambiar
        //self.txtResume.text = "Cantidad total del \(String(describing: components.day!)) de \(String(describing: self.monthsStr[components.month! - 1])) con 1000 citas ingresadas:"
        //getBalanceWeek()
        getBalanceWeekTwo()
        getAppoint()
    }
    
    func actualizarInfo() {
        getBalanceWeekTwo()
        getAppoint()
        self.fethcAppoinment()
    }
    
    func seActualizoCita() {
        getBalanceWeekTwo()
        getAppoint()
        self.fethcAppoinment()
    }
    
    func getBalanceWeekTwo(){
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.mode = MBProgressHUDMode.indeterminate
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let firstDate = "\(year)-\(month)-\(day)T00:00:00"
        //let lastDate = "\(year)-\(month)-\(day)T11:59:00"
        
        let queryBa =  PFQuery(className: "Balance")
        queryBa.whereKey("createdAt", greaterThanOrEqualTo: getDate(dateString: firstDate) ?? Date())
        //queryBa.whereKey("createdAt", lessThanOrEqualTo: getDate(dateString: lastDate) ?? Date())
        queryBa.findObjectsInBackground { (objects, error) in
            loader.hide(animated: true)
            if(error == nil ){
                
                var incomeBalance = 0.0
                for ba : PFObject in objects!{
                    let ty = ba.value(forKey: "type") as! String
                    if(ty == "income"){
                        incomeBalance += ba.value(forKey: "amount") as! Double
                    }else
                        {
                            let inco = ba.value(forKey: "amount") as! Double
                            incomeBalance = incomeBalance - inco
                        }
                    }
                    
                    
                    
                    self.txtAmount.text = "$\(self.doubletoString(incomeBalance))"
            }
        }
    }
    
    func formatearMonto(monto:Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.locale = Locale.current
        let doubleStr = currencyFormatter.string(from: NSNumber(value: monto))!
        
        return doubleStr
    }
    
    
    func getAppoint(){
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.mode = MBProgressHUDMode.indeterminate
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let firstDate = "\(year)-\(month)-\(day)T00:00:00"
        let lastDate = "\(year)-\(month)-\(day)T11:59:00"
        
        print("--DATE semana \(firstDate) - \(lastDate)")
        let queryApp =  PFQuery(className: "Appointment")
        queryApp.whereKey("date", greaterThanOrEqualTo: getDate(dateString: firstDate) ?? Date())
        queryApp.whereKey("date", lessThanOrEqualTo: getDate(dateString: lastDate) ?? Date())
        queryApp.findObjectsInBackground { (objects, error) in
            loader.hide(animated: true)
            if(error == nil ){
                
                if let citas = objects{
                    
                    self.txtResume.text = "Cantidad total del \(day) de \(String(describing: self.monthsStr[month - 1])) con \(citas.count) citas ingresadas:"
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fethcAppoinment()
    }
    
    
    @objc func tap(sender : UITapGestureRecognizer) {
        print("Gesture tap")
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        destination.pacienteUser = self.pacienteUser
        destination.delegateUserProfile = self
        self.show(destination, sender: nil)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer){
        if (sender.direction == .left){
            self.conteinerDate.isHidden = false
            self.containerDelete.isHidden = false
            self.rigthCons.constant = 100.0
            self.leftConsCard.constant = -50
            print("Swipe Left")
        }
        
        if (sender.direction == .right){
            self.conteinerDate.isHidden = true
            self.containerDelete.isHidden = true
            self.rigthCons.constant = 25.0
            self.leftConsCard.constant = 25.0
            print("Swipe Right")
            
        }
    }
    
    func fetchDataUser(){
        
        
    }
    
    func fethcAppoinment(){
        let queryApp = PFQuery(className: "Appointment")
        //queryApp.order(byDescending: "date")
        queryApp.order(byAscending: "date")
        queryApp.includeKey("patient.tutor")
        //queryApp.whereKey("date", lessThanOrEqualTo: Date())
        queryApp.whereKey("date", greaterThanOrEqualTo: self.yesterday())
        queryApp.cachePolicy = .networkElseCache
        queryApp.includeKey("patient")
        queryApp.getFirstObjectInBackground { (appo, error) in
            if(error == nil){
                self.proximaCita.isHidden = false
                self.imgUser.isHidden = false
                self.txtDate.isHidden = false
                self.sinProximaCita.isHidden = true
                self.sinProximaCita.text = ""
                self.imgHour.isHidden = false
                self.proximaCita.text = "PRÓXIMA CITA"
                self.clickAndSwipe()
                if let pac = appo{
                    self.paciente = pac
                }
                if var date = appo!.value(forKey: "date") as? Date{
                    
                    date = self.regresarFecha(date: date)
                          
                    
                    
                    let cale = Calendar.current
                    let components = cale.dateComponents([.year, .month, .day,.weekday], from: date)
                    let weekDay = self.weekDays[components.weekday! - 1]
                    self.txtDate.text = "\(String(describing: weekDay)) \(String(describing: components.day!)) de \(String(describing: self.monthsStr[components.month! - 1]))"
                }
                
                if let hrIni = appo!.value(forKey: "horaInicio") as? String{
                    if let hrFin = appo!.value(forKey: "horaFin") as? String{
                        self.txtHour.text = "\(hrIni) — \(hrFin)"
                    }
                }
                if let user = appo!.value(forKey: "patient") as? PFUser{
                    self.pacienteUser = user
                    if let name = user.value(forKey: "name") as? String{
                        if let last = user.value(forKey: "lastName") as? String{
                            self.txtName.text = "\(name) \(last)"
                        }
                    }
                    if let imageFile = user.object(forKey: "avatar") as? PFFileObject{
                        if imageFile.url != nil{
                            if let urlString = imageFile.url{
                                let urlFinal = URL(string: urlString)
                                self.imgUser.sd_setImage(with: urlFinal)
                                self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2
                                self.imgUser.clipsToBounds = true
                            }
                        }
                    }
                }
                
            }else{
                self.proximaCita.isHidden = true
                self.proximaCita.text = ""
                
                self.imgUser.isHidden = true
                self.txtDate.isHidden = true
                self.imgHour.isHidden = true
                self.txtName.text = ""
                self.txtDate.text = ""
                self.txtHour.text = ""
                self.sinProximaCita.isHidden = false
                self.sinProximaCita.text = "SIN PRÓXIMA CITA"
            }
        }
        
    }
    
    @IBAction func clickDelete(_ sender: Any) {
        if let pac = self.paciente{
            print("entro a hay pac")
            pac.deleteInBackground()
            self.rigthCons.constant = 25.0
            self.leftConsCard.constant = 25.0
            self.fethcAppoinment()
        }
    }
    
    @IBAction func clickReSchedule(_ sender: Any) {
        
        print("clickReSchedule")
        if let pac = self.paciente{
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "ReSheduleViewController") as! ReSheduleViewController
            destination.shedule = pac
            destination.delegate = self
            self.show(destination, sender: nil)
        }
        self.rigthCons.constant = 25.0
        self.leftConsCard.constant = 25.0
    }
    
    
    
    func getBalanceWeek(){
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.mode = MBProgressHUDMode.indeterminate
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        
        let firstDate = "\(year)-\(month)-\(day)T00:00:00"
        let lastDate = "\(year)-\(month)-\(day)T11:59:00"
        
        
        let queryBa =  PFQuery(className: "Balance")
        //queryBa.cachePolicy = .networkElseCache lessThanOrEqualTo
        queryBa.whereKey("createdAt", greaterThanOrEqualTo: getDate(dateString: firstDate) ?? Date())
        queryBa.whereKey("createdAt", lessThanOrEqualTo: getDate(dateString: lastDate) ?? Date())
        queryBa.whereKey("nutriologoId",equalTo: PFUser.current())
              
        queryBa.findObjectsInBackground { (objects, error) in
            loader.hide(animated: true)
            if(error == nil ){
                
                var incomeBalance = 0.0
                for ba : PFObject in objects!{
                    let ty = ba.value(forKey: "type") as! String
                    if(ty == "income"){
                        let inco = ba.value(forKey: "amount") as! Double
                        incomeBalance = incomeBalance + inco
                    }
                    else
                    {
                        let inco = ba.value(forKey: "amount") as! Double
                        incomeBalance = incomeBalance - inco
                    }
                }
                
                
                
                self.txtAmount.text = "$\(self.doubletoString(incomeBalance))"
                
            }
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
    
    
    func getTodayString(date: Date) -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        //formatter.timeStyle = .long
        // formatter.amSymbol = "AM"
        //formatter.pmSymbol = "PM"
        let currentDateStr = formatter.string(from: date)
        print(currentDateStr)
        return currentDateStr
    }
    
    
    func yesterday() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(-1, for: .day) // -1 day
        
        let now = Date() // Current date
        let yesterday = Calendar.current.date(byAdding: dateComponents, to: now) // Add the DateComponents
        
        return yesterday!
    }
    
    
    func cloud(){
        
        
        let params = NSMutableDictionary()
        PFCloud.callFunction(inBackground: "test", withParameters: params as? [AnyHashable : Any]) { (results, error) in
            
            if !(error != nil) {
                
                print("ENTROAL CLOUD \(results)")
                
            }else{
                print("ENTROAL CLOUD NOOOOOOOOOOOOO HAY")
            }
        }
        
        
        
        
    }
    
    
    func clickAndSwipe(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let tap = UITapGestureRecognizer(target: self, action:  #selector(self.tap))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        cardView.addGestureRecognizer(tap)
        cardView.addGestureRecognizer(leftSwipe)
        cardView.addGestureRecognizer(rightSwipe)
    }
    
    
}



