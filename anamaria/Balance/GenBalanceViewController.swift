//
//  GenBalanceViewController.swift
//  anamaria
//
//  Created by Francisco Constante on 3/12/19.
//  Copyright © 2019 nvn. All rights reserved.

import UIKit
import Parse
import MBProgressHUD

class GenBalanceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    var type : String!
    var isIncome = true
    var genBalance = 0.0
    
    var incomeBalance = 0.0
    var outcomeBalance = 0.0
    var balance = 0.0
    var caseDate = 0
    
    var balanceGeneral = [PFObject]()
    var balanceFilter = [PFObject]()
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("click click cick")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.viewTop.layer.cornerRadius = 30
       // self.viewTop.layer.masksToBounds = true
        self.lblTitle.text = type
    
        //getBalance()
        setUpData()
        caseDateLbl()
    }
    
    func caseDateLbl(){
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let last = lastDay(ofMonth: month, year: year)
        if(caseDate == 0){
           
            var newDay = day
            if((newDay-6) <= 0){
                newDay = 1
            }
            
            let firstDate = "\(year)-\(month)-\(newDay)T00:00:00"
            let lastDate = "\(year)-\(month)-\(day)T11:59:00"
            
            let one = "\(getTodayString(date: getDate(dateString: firstDate) ?? Date()))"
            let two = "\(getTodayString(date: getDate(dateString: lastDate) ?? Date()))"
    
            self.lblAmount.text = "Cantidad total\n\(newDay)/\(one)/\(year) — \(day)/\(two)/\(year)"
        }
        
        if(caseDate == 1){
            
            let firstDate = "\(year)-\(month)-\(1)T00:00:00"
            let lastDate = "\(year)-\(month)-\(last)T11:59:00"
            let one = "\(getTodayString(date: getDate(dateString: firstDate) ?? Date()))"
            let two = "\(getTodayString(date: getDate(dateString: lastDate) ?? Date()))"
            
            self.lblAmount.text = "Cantidad total\n\(1)/\(one)/\(year) — \(last)/\(two)/\(year)"
            
        }
        
        if(caseDate == 2){
            
            var monthTwo = month-2
            if((monthTwo) <= 0){
                monthTwo = 1
            }
            
            let firstDate = "\(year)-\(monthTwo)-\(1)T00:00:00"
            let lastDate = "\(year)-\(month)-\(last)T11:59:00"
            
            let one = "\(getTodayString(date: getDate(dateString: firstDate) ?? Date()))"
            let two = "\(getTodayString(date: getDate(dateString: lastDate) ?? Date()))"
            
            self.lblAmount.text = "Cantidad total\n\(1)/\(one)/\(year) - \(last)/\(two)/\(year)"
        }
    }
    
    func setUpData(){
       
        for ba : PFObject in balanceGeneral{
            let ty = ba.value(forKey: "type") as! String
            
            if(self.isIncome == true){
                if(ty == "income"){
                    balanceFilter.append(ba)
                    let inco = ba.value(forKey: "amount") as! Double
                    self.balance = self.balance + inco
                }
            }else{
                if(ty != "income"){
                    balanceFilter.append(ba)
                    let outco = ba.value(forKey: "amount") as! Double
                    self.balance = self.balance + outco
                }
            }
        }
       
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        
        if(self.type ==  "INGRESOS"){
            self.lblPrice.textColor = UIColor(red:0.33, green:0.73, blue:0.35, alpha:1)
        }else{
            self.lblPrice.textColor = UIColor(red:1, green:0.18, blue:0.4, alpha:1)
        }
        
        let doubleStr = self.doubletoString(self.balance)
        self.lblPrice.text = "$\(doubleStr)"
        self.tableView.reloadData()
        
    }
    
  /*  func getBalance(){
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.mode = MBProgressHUDMode.indeterminate
        
        let queryBa =  PFQuery(className: "Balance")
        
            if(self.type ==  "INGRESOS"){
                self.lblPrice.textColor = UIColor(red:0.33, green:0.73, blue:0.35, alpha:1)
                queryBa.whereKey("type", equalTo: "income")
            }else{
                self.lblPrice.textColor = UIColor(red:1, green:0.18, blue:0.4, alpha:1)
                queryBa.whereKey("type", equalTo: "outcome")
            }
        
        queryBa.cachePolicy = .networkElseCache
        queryBa.findObjectsInBackground { (objects, error) in
            loader.hide(animated: true)
            
            if(error == nil ){
                for ba : PFObject in objects!{
                    let inco = ba.value(forKey: "amount") as! Double
                    self.genBalance = self.genBalance + inco
                }
                
                let currencyFormatter = NumberFormatter()
                currencyFormatter.usesGroupingSeparator = true
                currencyFormatter.numberStyle = .currency
                currencyFormatter.locale = Locale.current
                
                let incomeString = currencyFormatter.string(from: NSNumber(value: self.genBalance))!
                
                self.lblPrice.text = incomeString
            
            }
        }
    }*/
    
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

extension GenBalanceViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.balanceFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
         let cell = Bundle.main.loadNibNamed("BalanceViewCell", owner: self, options: nil)?.first as! BalanceViewCell
        
        let balance = self.balanceFilter[indexPath.row]
        if(self.type ==  "INGRESOS"){
            cell.lblPrice.textColor = UIColor(red:0.33, green:0.73, blue:0.35, alpha:1)
        }else{
            cell.lblPrice.textColor = UIColor(red:1, green:0.18, blue:0.4, alpha:1)
        }
        
        if let concept = balance.object(forKey: "concept") as? String{
           cell.lblConcept.text = concept
        }
        
        if let amount = balance.object(forKey: "amount") as? Double{
             let doubleStr = self.doubletoString(amount)
            cell.lblPrice.text = "$\(doubleStr)"
        }
        
        
        return cell
    }
    
    
}
