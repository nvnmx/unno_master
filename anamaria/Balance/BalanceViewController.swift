//
//  BalanceViewController.swift
//  anamaria
//
//  Created by Francisco on 1/1/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit
import Parse
import SwiftChart
import MBProgressHUD

protocol balanceViewControllerDelegate: AnyObject {
    func reload()
}

class BalanceViewController: UIViewController,PopBalanceViewControllerProtocol {
  
    
    let colorBlue = UIColor(red:0.41, green:0.20, blue:0.94, alpha:1.0)
    
    @IBOutlet weak var viewTrim: UIView!
    @IBOutlet weak var viewMonth: UIView!
    @IBOutlet weak var viewWeek: UIView!
    @IBOutlet weak var lblIncome: UILabel!
    @IBOutlet weak var viewOutcome: UIView!
    @IBOutlet weak var lblOutcome: UILabel!
    @IBOutlet weak var viewIncome: UIView!
    @IBOutlet weak var balanceStats: Chart!
    
    @IBOutlet weak var btnWeek: UIButton!
    @IBOutlet weak var btnM: UIButton!
    @IBOutlet weak var btnT: UIButton!
    
    var incomeBalance = 0.0
    var outcomeBalance = 0.0
    var caseDate = 0
    
    var chartIncome = [Double]()
    var chartOutcome = [Double]()
    
    var balanceGeneral = [PFObject]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //getBalance()
        print("aqui entro al willappear")
        dateWeek()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCardStyle(view: self.viewIncome)
        self.setCardStyle(view: self.viewOutcome)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BalanceViewController.snapShot(_sender:)))
        
        self.viewIncome.isUserInteractionEnabled = true
        self.viewIncome.addGestureRecognizer(tapGesture)
        
        let tapGestureOut = UITapGestureRecognizer(target: self, action: #selector(BalanceViewController.goBalance(_sender:)))
        
        self.viewOutcome.isUserInteractionEnabled = true
        self.viewOutcome.addGestureRecognizer(tapGestureOut)
        
    }
    
    func actualizarMontos() {
          dateWeek()
      }
      
    
    @IBAction func addBalance(_ sender: Any) {
        
        let popVc : PopBalanceViewController = self.storyboard!.instantiateViewController(withIdentifier: "nuevoBalance") as! PopBalanceViewController
               
               
               popVc.delegate = self
               self.present(popVc, animated: true, completion: nil)
        
       // self.performSegue(withIdentifier: "balPop", sender: nil)
    }
    
    @objc func snapShot(_sender: UITapGestureRecognizer){
        
        let bale = self.storyboard?.instantiateViewController(withIdentifier: "balanceProfile") as! GenBalanceViewController
        bale.type = "INGRESOS"
        bale.isIncome = true
        bale.caseDate = self.caseDate
        bale.balanceGeneral = self.balanceGeneral
        self.show(bale, sender: nil)
        
    }
    
    func dateWeek(){
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        var newDay = day-6
        if(newDay <= 0){
            newDay = 1
        }
    
        let firstDate = "\(year)-\(month)-\(newDay)T00:00:00"
        let lastDate = "\(year)-\(month)-\(day)T11:59:00"
        
        let one = "\(getTodayString(date: getDate(dateString: firstDate) ?? Date()))"
        let two = "\(getTodayString(date: getDate(dateString: lastDate) ?? Date()))"
    
        btnWeek.setTitle("\(newDay)\(one) — \(day)\(two)",for: .normal)
        
        self.getBalanceWeek()
    }
    
    @objc func goBalance(_sender: UITapGestureRecognizer){
        
        let bale = self.storyboard?.instantiateViewController(withIdentifier: "balanceProfile") as! GenBalanceViewController
        bale.type = "EGRESOS"
        bale.isIncome = false
        bale.caseDate = self.caseDate
        bale.balanceGeneral = self.balanceGeneral
        self.show(bale, sender: nil)
        
    }
    
    
    func getBalanceWeek(){
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.mode = MBProgressHUDMode.indeterminate
        
        self.incomeBalance = 0.0
        self.outcomeBalance = 0.0
        
        self.chartIncome = [Double]()
        self.chartOutcome = [Double]()
        
        self.balanceStats.removeAllSeries()
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        var newDay = day-6
        if(newDay <= 0){
            newDay = 1
        }
        
        let firstDate = "\(year)-\(month)-\(newDay)T00:00:00"
        let lastDate = "\(year)-\(month)-\(day+1)T11:59:00"
        
      print("DATE semana \(firstDate) — \(lastDate)")
        let queryBa =  PFQuery(className: "Balance")
        //queryBa.cachePolicy = .networkElseCache lessThanOrEqualTo
        queryBa.whereKey("createdAt", greaterThanOrEqualTo: getDate(dateString: firstDate) ?? Date())
        queryBa.whereKey("createdAt", lessThanOrEqualTo: getDate(dateString: lastDate) ?? Date())
        queryBa.whereKey("nutriologoId",equalTo: PFUser.current())
        queryBa.findObjectsInBackground { (objects, error) in
            loader.hide(animated: true)
            if(error == nil ){
                
                self.balanceGeneral = objects ?? [PFObject]()
                for ba : PFObject in objects!{
                    let ty = ba.value(forKey: "type") as! String
                    if(ty == "income"){
                        let inco = ba.value(forKey: "amount") as! Double
                        self.incomeBalance = self.incomeBalance + inco
                        self.chartIncome.append(inco)
                    }else{
                        let outco = ba.value(forKey: "amount") as! Double
                        self.outcomeBalance = self.outcomeBalance + outco
                        self.chartOutcome.append(outco)
                    }
                }
                
             /*   let currencyFormatter = NumberFormatter()
                currencyFormatter.usesGroupingSeparator = true
                currencyFormatter.numberStyle = .currency
                currencyFormatter.locale = Locale.current
                
                let incomeString = currencyFormatter.string(from: NSNumber(value: self.incomeBalance))!
                let outcomeString = currencyFormatter.string(from: NSNumber(value: self.outcomeBalance))!
               */
                
                self.lblIncome.text = "$ "+self.doubletoString(self.incomeBalance)
                self.lblOutcome.text = "$ "+self.doubletoString(self.outcomeBalance)
                
                let serInc = ChartSeries(self.chartIncome)
                serInc.color = UIColor(red:0.33, green:0.73, blue:0.35, alpha:1)
                serInc.area = true
                
                let serOut = ChartSeries(self.chartOutcome)
                serOut.color = UIColor(red:1, green:0.18, blue:0.4, alpha:1)
                    //ChartColors.redColor()
                serOut.area = true
                
                self.balanceStats.add([serInc,serOut])
            }
        }
    }
    
    func getBalanceMonth(){
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.mode = MBProgressHUDMode.indeterminate
        
        self.incomeBalance = 0.0
        self.outcomeBalance = 0.0
        
        self.chartIncome = [Double]()
        self.chartOutcome = [Double]()
        
        self.balanceStats.removeAllSeries()
        
        let date = Date()
        let calendar = Calendar.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        dateFormatter.locale = Locale(identifier: "es")
        let nameOfMonth = dateFormatter.string(from: date)
        
        self.btnM.setTitle(nameOfMonth.uppercased(), for: .normal)
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let last = lastDay(ofMonth: month, year: year)
        
        let firstDate = "\(year)-\(month)-\(1)T00:00:00"
        let lastDate = "\(year)-\(month)-\(last)T11:59:00"
        
        print("DATE mes \(firstDate) — \(lastDate)")
        let queryBa =  PFQuery(className: "Balance")
        //queryBa.cachePolicy = .networkElseCache lessThanOrEqualTo
        queryBa.whereKey("createdAt", greaterThanOrEqualTo: getDate(dateString: firstDate) ?? Date())
        queryBa.whereKey("createdAt", lessThanOrEqualTo: getDate(dateString: lastDate) ?? Date())
        queryBa.findObjectsInBackground { (objects, error) in
            loader.hide(animated: true)
            if(error == nil ){
                self.balanceGeneral = objects ?? [PFObject]()
                for ba : PFObject in objects!{
                    let ty = ba.value(forKey: "type") as! String
                    if(ty == "income"){
                        let inco = ba.value(forKey: "amount") as! Double
                        self.incomeBalance = self.incomeBalance + inco
                        self.chartIncome.append(inco)
                    }else{
                        let outco = ba.value(forKey: "amount") as! Double
                        self.outcomeBalance = self.outcomeBalance + outco
                        self.chartOutcome.append(outco)
                    }
                }
                
                let currencyFormatter = NumberFormatter()
                currencyFormatter.usesGroupingSeparator = true
                currencyFormatter.numberStyle = .currency
                currencyFormatter.locale = Locale.current
                
                let incomeString = currencyFormatter.string(from: NSNumber(value: self.incomeBalance))!
                let outcomeString = currencyFormatter.string(from: NSNumber(value: self.outcomeBalance))!
                
                
                self.lblIncome.text = "$ "+self.doubletoString(self.incomeBalance)
                self.lblOutcome.text = "$ "+self.doubletoString(self.outcomeBalance)
                
                let serInc = ChartSeries(self.chartIncome)
                serInc.color = UIColor(red:0.33, green:0.73, blue:0.35, alpha:1)
                serInc.area = true
                
                let serOut = ChartSeries(self.chartOutcome)
                serOut.color = UIColor(red:1, green:0.18, blue:0.4, alpha:1)
                //ChartColors.redColor()
                serOut.area = true
                
                self.balanceStats.add([serInc,serOut])
            }
        }
    }
    
    
    func getBalanceTrim(){
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.mode = MBProgressHUDMode.indeterminate
        
        self.incomeBalance = 0.0
        self.outcomeBalance = 0.0
        
        self.chartIncome = [Double]()
        self.chartOutcome = [Double]()
        
        self.balanceStats.removeAllSeries()
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let last = lastDay(ofMonth: month, year: year)
        
        var monthTwo = month-2
        if((monthTwo) <= 0){
            monthTwo = 1
        }
        
        
        
        
        
        let firstDate = "\(year)-\(monthTwo)-\(1)T00:00:00"
        let lastDate = "\(year)-\(month)-\(last)T11:59:00"
        
        
        let dateFormatterf = DateFormatter()
        dateFormatterf.dateFormat = "yyyy-MM-dd"
        let primerFecha = dateFormatterf.date (from:"\(year)-\(monthTwo)-01")!
        let segundaFecha = dateFormatterf.date (from:"\(year)-\(month)-01")!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        dateFormatter.locale = Locale(identifier: "es")
        let nombrePrimer = dateFormatter.string(from: primerFecha)
        let nombreSegundo = dateFormatter.string(from: segundaFecha)
        
        self.btnT.setTitle(nombrePrimer.uppercased().prefix(3)+" - "+nombreSegundo.uppercased().prefix(3), for: .normal)
        
        print("DATE trim \(firstDate) — \(lastDate)")
        
        let queryBa =  PFQuery(className: "Balance")
        //queryBa.cachePolicy = .networkElseCache lessThanOrEqualTo
        queryBa.whereKey("createdAt", greaterThanOrEqualTo: getDate(dateString: firstDate) ?? Date())
        queryBa.whereKey("createdAt", lessThanOrEqualTo: getDate(dateString: lastDate) ?? Date())
        queryBa.findObjectsInBackground { (objects, error) in
            loader.hide(animated: true)
            if(error == nil ){
                self.balanceGeneral = objects ?? [PFObject]()
                for ba : PFObject in objects!{
                    let ty = ba.value(forKey: "type") as! String
                    if(ty == "income"){
                        let inco = ba.value(forKey: "amount") as! Double
                        self.incomeBalance = self.incomeBalance + inco
                        self.chartIncome.append(inco)
                    }else{
                        let outco = ba.value(forKey: "amount") as! Double
                        self.outcomeBalance = self.outcomeBalance + outco
                        self.chartOutcome.append(outco)
                    }
                }
                
                let currencyFormatter = NumberFormatter()
                currencyFormatter.usesGroupingSeparator = true
                currencyFormatter.numberStyle = .currency
                currencyFormatter.locale = Locale.current
                
                let incomeString = currencyFormatter.string(from: NSNumber(value: self.incomeBalance))!
                let outcomeString = currencyFormatter.string(from: NSNumber(value: self.outcomeBalance))!
                
                
                self.lblIncome.text = "$ "+self.doubletoString(self.incomeBalance)
                self.lblOutcome.text = "$ "+self.doubletoString(self.outcomeBalance)
                let serInc = ChartSeries(self.chartIncome)
                serInc.color = UIColor(red:0.33, green:0.73, blue:0.35, alpha:1)
                serInc.area = true
                
                let serOut = ChartSeries(self.chartOutcome)
                serOut.color = UIColor(red:1, green:0.18, blue:0.4, alpha:1)
                //ChartColors.redColor()
                serOut.area = true
                
                self.balanceStats.add([serInc,serOut])
            }
        }
    }
    
    
    
    
    
    @IBAction func thisWeek(_ sender: Any) {
        caseDate = 0
       self.viewTrim.isHidden = true
       self.viewMonth.isHidden = true
       self.viewWeek.isHidden = false
       dateWeek()
        self.btnT.setTitle("TRIMESTRAL", for: .normal)
        self.btnM.setTitle("MENSUAL", for: .normal)
        self.btnWeek.setTitleColor(self.colorBlue, for: .normal)
        self.btnM.setTitleColor(UIColor.lightGray, for: .normal)
        self.btnT.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
    @IBAction func thisMonth(_ sender: Any) {
        caseDate = 1
        self.viewTrim.isHidden = true
        self.viewMonth.isHidden = false
        self.viewWeek.isHidden = true
        self.getBalanceMonth()
        self.btnWeek.setTitle("SEMANAL", for: .normal)
        self.btnT.setTitle("TRIMESTRAL", for: .normal)
        self.btnWeek.setTitleColor(UIColor.lightGray, for: .normal)
        self.btnM.setTitleColor(self.colorBlue, for: .normal)
        self.btnT.setTitleColor(UIColor.lightGray, for: .normal)
    }
    @IBAction func thisThrim(_ sender: Any) {
        caseDate = 2
        self.viewTrim.isHidden = false
        self.viewMonth.isHidden = true
        self.viewWeek.isHidden = true
        getBalanceTrim()
        self.btnWeek.setTitle("SEMANAL", for: .normal)
        self.btnM.setTitle("MENSUAL", for: .normal)
        self.btnWeek.setTitleColor(UIColor.lightGray, for: .normal)
        self.btnM.setTitleColor(UIColor.lightGray, for: .normal)
        self.btnT.setTitleColor(self.colorBlue, for: .normal)
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
    
    func lastDay(ofMonth m: Int, year y: Int) -> Int {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: y, month: m)
        comps.setValue(m + 1, for: .month)
        comps.setValue(0, for: .day)
        let date = cal.date(from: comps)!
        return cal.component(.day, from: date)
    }
}

extension BalanceViewController : balanceViewControllerDelegate{
    
    func reload() {
        
    }

}
