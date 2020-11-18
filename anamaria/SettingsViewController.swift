//
//  SettingsViewController.swift
//  anamaria
//
//  Created by Francisco on 12/16/18.
//  Copyright © 2018 nvn. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    @IBOutlet weak var conteinerCount: UIView!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var containerShedule: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if(getTypeUser()){
            containerShedule.isHidden = true
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.getNotification()
    }
    
    @IBAction func contact(_ sender: Any) {
    }
    
    @IBAction func oepnPrivacy(_ sender: Any) {
    }
    @IBAction func logOut(_ sender: Any) {
        if PFUser.current() != nil{
            let alert = UIAlertController(title: "", message: "¿Seguro que deseas cerrar sesión?", preferredStyle: UIAlertController.Style.alert)
            
            let correct = UIAlertAction(title: "Si", style: .default) { (_) in
                PFUser.logOut()
                 let vc = (self.storyboard?.instantiateViewController(withIdentifier: "logIn"))!
                vc.modalPresentationStyle = .fullScreen
                       self.show(vc, sender: nil)
                
               
                
            }
            
            let okAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil)
            
            
            alert.addAction(correct)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func openTerms(_ sender: Any) {
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func showNotifications(_ sender: Any) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
        self.show(destination, sender: nil)
    }
    
    
    @IBAction func showConsutas(_ sender: Any) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "ConsultasViewController") as! ConsultasViewController
        self.show(destination, sender: nil)
    }
    
    
    
    func getNotification(){
        
        if let user = PFUser.current(){
            let query = PFQuery(className:"Notification")
            query.whereKey("isRead", equalTo: false)
            query.whereKey("user", equalTo: user)
            query.countObjectsInBackground { (count: Int32, error: Error?) in
                if let error = error {
                    // The request failed
                    print(error.localizedDescription)
                    self.conteinerCount.isHidden = true
                } else {
                    print("Entro Notifications \(count)")
                    self.lblNotification.text = "\(count)"
                    self.conteinerCount.isHidden = false
                    if(count == 0){
                        self.conteinerCount.isHidden = true
                    }
                    
                }
            }
        }
        
    }
  
    
    
    
}
