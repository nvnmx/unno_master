//
//  SearchAppoimentViewController.swift
//  anamaria
//
//  Created by ArturoGR on 9/8/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class SearchAppoimentViewController: UIViewController {

    @IBOutlet weak var countAppoiment: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
       var monthsStr = ["Enero", "Febrero", "Marzo","Abril","Mayo","Junio","Julio","Agosto", "Septiembre","Octubre","Noviembre", "Diciembre"]
    
    struct Objects {
        var section : String
        var citas = [PFObject]()
    }
    
    var citasGroup = [Objects] ()
     var citasGroupAll = [Objects] ()
    
    var citas:[PFObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchAppoimentViewController.dissmisKeyboard))
                             view.addGestureRecognizer(tap)
        
        getAppoinments()
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.black
            }
            
        }
        
    }
    

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getAppoinments(){
        self.citas = []
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.mode = MBProgressHUDMode.indeterminate
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let last = lastDay(ofMonth: month, year: year)
        
        print("ENTROALMES \(month)")
        
        let firstDate = "\(year)-\(month)-\(1)T00:00:00"
        let lastDate = "\(year)-\(month)-\(last)T11:59:00"
        
        let queryApp = PFQuery(className: "Appointment")
        queryApp.order(byAscending: "date")
        queryApp.includeKey("patient")
        queryApp.whereKey("date", greaterThanOrEqualTo: getDate(dateString: firstDate) ?? Date())
        queryApp.whereKey("date", lessThanOrEqualTo: getDate(dateString: lastDate) ?? Date())
        queryApp.cachePolicy = .networkElseCache
        queryApp.findObjectsInBackground { (objects, error) in
            loader.hide(animated: true)
            
            if(error == nil ){
                for pa:PFObject in objects!{
                    self.citas.append(pa)
                }
                
                var section: [String] = []
                for noti:PFObject in objects!{
                    
                    if let name = noti.value(forKey: "date") as? Date{
                        let headerChar = self.getTodayString(date: name)
                        
                        if(!section.contains(headerChar)){
                            section.append(headerChar)
                            self.citasGroup.append(Objects(section: headerChar, citas: self.getSetions(notifications: objects!, tittle: headerChar) ))
                        }
                    }
                }
                self.citasGroupAll = self.citasGroup
                self.countAppoiment.text = "\(self.citas.count) citas en \(self.monthsStr[month-1]) (mes en curso)"
                //self.tableView.reloadData()
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
    
    func lastDay(ofMonth m: Int, year y: Int) -> Int {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: y, month: m)
        comps.setValue(m + 1, for: .month)
        comps.setValue(0, for: .day)
        let date = cal.date(from: comps)!
        return cal.component(.day, from: date)
    }
}

extension SearchAppoimentViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderNotification.createMyClassView()
        header.lblTitle.text = "\(self.citasGroup[section].section)"
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.citasGroup.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.citasGroup[section].section)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.citasGroup[section].citas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CalendarAppoViewCell", owner: self, options: nil)?.first as! CalendarAppoViewCell
        
        let ci = self.citasGroup[indexPath.section].citas[indexPath.row]
     
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
                cell.lblHour.text = "\(inicio) \(fin)"
            }
        }
        
        cell.onButtonTapped = {
            
            if let user = ci.value(forKey: "patient") as? PFUser{
                
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                destination.pacienteUser = user
                self.show(destination, sender: nil)
                
                
            }
            
        }
        
        
        //cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
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
    
    func getSetions(notifications : [PFObject], tittle: String) -> [PFObject] {
        
        var count = 0
        var newNoti:[PFObject] = [PFObject]()
        
        for noti in notifications{
            count = count + 1
            
            if let header = noti.value(forKey: "date") as? Date{
                let headerChar = self.getTodayString(date: header)
                if(headerChar == tittle){
                    newNoti.append(noti)
                }
            }
        }
        return newNoti
    }
    
    func newSetions(patients : [PFObject], tittle: String,filter: String) -> [PFObject] {
        
        var count = 0
        var pac:[PFObject] = [PFObject]()
        
        for paciente in patients{
            count = count + 1
            
            if let header = paciente.value(forKey: "date") as? Date{
                let headerChar = self.getTodayString(date: header)
                
                if(headerChar == tittle){
                    if(headerChar.lowercased().contains(filter.lowercased())){
                        pac.append(paciente)
                    }
                }
            }
        }
        return pac
    }
}

extension SearchAppoimentViewController: UISearchBarDelegate{
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            tableView.isHidden = true
            countAppoiment.isHidden = false
            dissmisKeyboard()
        }else{
            tableView.reloadData()
            tableView.isHidden = false
            countAppoiment.isHidden = true
            filterContentForSearchText(searchText)
        }
        
         print("TEXTO   \(searchText)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.text = ""
        searchBar.showsCancelButton = false
        dissmisKeyboard()
    }
    
    @objc func dissmisKeyboard(){
        view.endEditing(true)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        if(searchText == ""){
            self.citasGroup = self.citasGroupAll
        }else{
            var citaNew:[Objects] = [Objects]()
            
            for citas in self.citasGroupAll{
                if let newObj = createFilter(objec: citas, filter: searchText){
                    citaNew.append(newObj)
                }
            }

            self.citasGroup = citaNew
        }
        tableView.reloadData()
    }
    
    func createFilter(objec: Objects,filter: String) -> Objects?{
        var citasNew = [PFObject]()
        for cita in objec.citas{
            if let pa = cita.value(forKey: "patient") as? PFUser{
                if let name = pa.value(forKey: "name") as? String{
                    if(name.lowercased().contains(filter.lowercased())){
                        citasNew.append(cita)
                    }
                }
            }
        }
        
        if(citasNew.count == 0){
            return nil
        }else{
           return Objects(section: objec.section, citas: citasNew)
        }
        
    }
    
}

