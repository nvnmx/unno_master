//
//  NotificationsViewController.swift
//  anamaria
//
//  Created by ArturoGR on 8/18/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit
import Parse

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct Objects {
        var section : String
        var notifications = [PFObject]()
    }
    
    var notificationsGroup = [Objects] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotification()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getNotification(){
        print("ENTRO AL PFUSER")
        if let user = PFUser.current(){
            
            
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let last = lastDay(ofMonth: month, year: year)
            
            let firstDate = "\(year)-\(month)-\(1)T00:00:00"
            let lastDate = "\(year)-\(month)-\(last)T11:59:00"
            
            let query = PFQuery(className:"Notification")
            //query.whereKey("isRead", equalTo: false)
            query.whereKey("createdAt", greaterThanOrEqualTo: getDate(dateString: firstDate) ?? Date())
            query.whereKey("createdAt", lessThanOrEqualTo: getDate(dateString: lastDate) ?? Date())
            query.whereKey("user", equalTo: user)
            query.includeKey("userCita")
            query.order(byDescending: "createdAt")
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let objects = objects {
                    
                    var section: [String] = []
                    self.notificationsGroup.removeAll()
                    for noti:PFObject in objects{
                        
                        if let name = noti.createdAt{
                            let headerChar = self.getTodayString(date: name)
                            
                            if(!section.contains(headerChar)){
                                
                                let notificaciones = self.getSetions(notifications: objects, tittle: headerChar)
                                if notificaciones.count > 0
                                {
                                    section.append(headerChar)
                                    self.notificationsGroup.append(Objects(section: headerChar, notifications: notificaciones ))
                                }
                            }
                        }
                    }
                    
                    
                  
                    
                    self.tableView.reloadData()
                    
                }
            }
        }
        
    }
    
    @IBAction func eliminarNotificaciones(_ sender: Any) {
        
        let notificaciones = self.notificationsGroup
        for seccion in notificaciones{
            for noti in seccion.notifications{
                let id = noti.objectId ?? ""
                ponerComoLeida(objectId: id)
            }
        }
        
        getNotification()
        
    }
    
    func ponerComoLeida(objectId: String)
    {
        let bal = PFObject(className: "Notification")
        bal.setValue(objectId, forKey: "objectId")
        bal.setValue(true, forKey: "isRead")
        
        do {
            try bal.save()
        } catch  {
            print(error)
        }
        
        /* bal.saveInBackground { (success, error) in
         if(success){
         self.dismiss(animated: true, completion: nil)
         }else{
         self.createAlert(title: "Atención!", message: "No se guardo el balance correctamente")
         }
         }
         */
    }
    
    
    func getSetions(notifications : [PFObject], tittle: String) -> [PFObject] {
        
        var count = 0
        var newNoti:[PFObject] = [PFObject]()
        
        for noti in notifications{
            count = count + 1
            
            if let header = noti.createdAt{
                let headerChar = self.getTodayString(date: header)
                if(headerChar == tittle){
                    let isRead = noti.object(forKey: "isRead") as? Bool ?? false
                    if !isRead
                    {
                        newNoti.append(noti)
                    }
                }
            }
        }
        return newNoti
    }
    
}


extension NotificationsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderNotification.createMyClassView()
        header.lblTitle.text = "\(self.notificationsGroup[section].section)"
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.notificationsGroup.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.notificationsGroup[section].section)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationsGroup[section].notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("NotificationViewCell", owner: self, options: nil)?.first as! NotificationViewCell
        let noti = self.notificationsGroup[indexPath.section].notifications[indexPath.row]
        
        if let schedule = noti.object(forKey: "schedule") as? String{
            cell.lblMessage.text = schedule
        }
        
        if let userName = noti.object(forKey: "userName") as? String{
            cell.lblName.text = userName
        }
        
        cell.onButtonTapped = {
            
            if let userCita = noti.object(forKey: "userCita") as? PFUser{
                
                
                
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                destination.pacienteUser = userCita
                self.show(destination, sender: nil)
            }
            
        }
        
        
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
    
    func lastDay(ofMonth m: Int, year y: Int) -> Int {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: y, month: m)
        comps.setValue(m + 1, for: .month)
        comps.setValue(0, for: .day)
        let date = cal.date(from: comps)!
        return cal.component(.day, from: date)
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
