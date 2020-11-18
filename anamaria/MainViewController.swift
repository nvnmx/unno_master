//
//  MainViewController.swift
//  anamaria
//
//  Created by Francisco on 12/4/18.
//  Copyright © 2018 nvn. All rights reserved.

import UIKit
import Parse


protocol MainViewDelegate: AnyObject {
    func openBalance()
}

class MainViewController: UIViewController,UserProfileViewControllerProtocol{
   
    
    let colorP = UIColor(red:0.44, green:0.31, blue:0.85, alpha:1)
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tabBar: UIView!
    @IBOutlet weak var viewHome: UIView!
    @IBOutlet weak var viewPatients: UIView!
    @IBOutlet weak var viewCalendar: UIView!
    @IBOutlet weak var viewIncomes: UIView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewMesures: UIView!
    @IBOutlet weak var viewPorciones: UIView!
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnPatient: UIButton!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var btnIncome: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnMesures: UIButton!
    @IBOutlet weak var btnPorciones: UIButton!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img7: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadHome()
        
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.btnHome.sendActions(for: .touchUpInside)
        }
    }
    
    
    
    
    
    
    func loadHome(){
        tabHome()
        self.setCleanViews()
        
        if(getTypeUser()){
            viewIncomes.isHidden = true
            viewPatients.isHidden = true
            viewCalendar.isHidden = true
            let destination = self.storyboard!.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            destination.pacienteUser = PFUser.current()!
            destination.isPatient = true
            destination.delegateUserProfile = self
            self.mainView.addSubview(destination.view)
            self.addChild(destination)
            
        }else{
           
            let controller3 = self.storyboard!.instantiateViewController(withIdentifier: "first") as! FirstViewController
            controller3.delegateMain = self
            viewMesures.isHidden = true
            viewPorciones.isHidden = true
            self.mainView.addSubview(controller3.view)
            self.addChild(controller3)
        }
        
        //btnHome.sendActions(for: .touchUpInside)
    }
    
    func actualizarInfo() {
           loadHome()
       }
    
    @IBAction func goHome(_ sender: Any) {
        loadHome()
    }
    
    @IBAction func goPatient(_ sender: Any) {
        tabPatients()
        self.setCleanViews()
        let controller3 = self.storyboard!.instantiateViewController(withIdentifier: "patients") as! PatientsViewController
        self.mainView.addSubview(controller3.view)
        self.addChild(controller3)
    }
    @IBAction func goCalendar(_ sender: Any) {
        tabCalendar()
        self.setCleanViews()
        let controller3 = self.storyboard!.instantiateViewController(withIdentifier: "calendar") as! CalendarViewController
        self.mainView.addSubview(controller3.view)
        self.addChild(controller3)
    }
    @IBAction func goIncome(_ sender: Any) {
        tabIncomes()
        self.setCleanViews()
        let controller3 = self.storyboard!.instantiateViewController(withIdentifier: "balance") as! BalanceViewController
        self.mainView.addSubview(controller3.view)
        self.addChild(controller3)
    }
    @IBAction func goProfile(_ sender: Any) {
        tabProfile()
        self.setCleanViews()
        let controller3 = self.storyboard!.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        self.mainView.addSubview(controller3.view)
        self.addChild(controller3)
    }
    
    @IBAction func goMesure(_ sender: Any) {
        tabMesures()
        self.setCleanViews()
        let controller3 = self.storyboard!.instantiateViewController(withIdentifier: "mesures") as! MesuresViewController
        self.mainView.addSubview(controller3.view)
        self.addChild(controller3)
    }
    
    @IBAction func goPortions(_ sender: Any) {
        tabPorciones()
        self.setCleanViews()
        let controller3 = self.storyboard!.instantiateViewController(withIdentifier: "swiper") as! SwipeViewController
        self.mainView.addSubview(controller3.view)
        self.addChild(controller3)
    }
    
    @IBAction func goSettings(_ sender: Any) {
        PFUser.logOut()
        UIApplication.shared.unregisterForRemoteNotifications()
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "logIn"))! 
        self.present(vc, animated: true, completion: nil)
    }
    
    func tabHome(){
        self.tabBarTint(imgSelect: img1, imgs: [img2,img3,img4,img5,img6,img7], names: ["home","patients","calendar","incomes","profile","patient","portions"])
        self.setBtnTabStyleSelected(view: viewHome)
        self.setBtnTabStyle(view: viewPatients)
        self.setBtnTabStyle(view: viewCalendar)
        self.setBtnTabStyle(view: viewIncomes)
        self.setBtnTabStyle(view: viewProfile)
        self.setBtnTabStyle(view: viewMesures)
        self.setBtnTabStyle(view: viewPorciones)
    }
    
    func tabPatients(){
        self.tabBarTint(imgSelect: img2, imgs: [img1,img3,img4,img5,img6,img7], names: ["patients","home","calendar","incomes","profile","patient","portions"])
        self.setBtnTabStyleSelected(view: viewPatients)
        self.setBtnTabStyle(view: viewHome)
        self.setBtnTabStyle(view: viewCalendar)
        self.setBtnTabStyle(view: viewIncomes)
        self.setBtnTabStyle(view: viewProfile)
        self.setBtnTabStyle(view: viewMesures)
        self.setBtnTabStyle(view: viewPorciones)
    }
    
    func tabCalendar(){
        self.tabBarTint(imgSelect: img3, imgs: [img1,img2,img4,img5,img6,img7], names: ["calendar","home","patients","incomes","profile","patient","portions"])
        self.setBtnTabStyleSelected(view: viewCalendar)
        self.setBtnTabStyle(view: viewPatients)
        self.setBtnTabStyle(view: viewHome)
        self.setBtnTabStyle(view: viewIncomes)
        self.setBtnTabStyle(view: viewProfile)
        self.setBtnTabStyle(view: viewMesures)
        self.setBtnTabStyle(view: viewPorciones)
    }
    
    func tabIncomes(){
        self.tabBarTint(imgSelect: img4, imgs: [img1,img2,img3,img5,img6,img7], names: ["incomes","home","patients","calendar","profile","patient","portions"])
        self.setBtnTabStyleSelected(view: viewIncomes)
        self.setBtnTabStyle(view: viewPatients)
        self.setBtnTabStyle(view: viewCalendar)
        self.setBtnTabStyle(view: viewHome)
        self.setBtnTabStyle(view: viewProfile)
        self.setBtnTabStyle(view: viewMesures)
        self.setBtnTabStyle(view: viewPorciones)
    }
    
    func tabProfile(){
        self.tabBarTint(imgSelect: img5, imgs: [img1,img2,img3,img4,img6,img7], names: ["profile","home","patients","calendar","incomes","patient","portions"])
        self.setBtnTabStyleSelected(view: viewProfile)
        self.setBtnTabStyle(view: viewPatients)
        self.setBtnTabStyle(view: viewCalendar)
        self.setBtnTabStyle(view: viewIncomes)
        self.setBtnTabStyle(view: viewHome)
        self.setBtnTabStyle(view: viewMesures)
        self.setBtnTabStyle(view: viewPorciones)
    }
    
    func tabMesures(){
        self.tabBarTint(imgSelect: img6, imgs: [img1,img2,img3,img4,img5,img7], names: ["patient","home","patients","calendar","incomes","profile","portions"])
        self.setBtnTabStyleSelected(view: viewMesures)
        self.setBtnTabStyle(view: viewPatients)
        self.setBtnTabStyle(view: viewCalendar)
        self.setBtnTabStyle(view: viewIncomes)
        self.setBtnTabStyle(view: viewHome)
        self.setBtnTabStyle(view: viewProfile)
        self.setBtnTabStyle(view: viewPorciones)
    }
    
    func tabPorciones(){
           self.tabBarTint(imgSelect: img7, imgs: [img1,img2,img3,img4,img5,img6], names: ["portions","home","patients","calendar","incomes","profile","patient"])
           self.setBtnTabStyleSelected(view: viewPorciones)
           self.setBtnTabStyle(view: viewPatients)
           self.setBtnTabStyle(view: viewCalendar)
           self.setBtnTabStyle(view: viewIncomes)
           self.setBtnTabStyle(view: viewHome)
           self.setBtnTabStyle(view: viewProfile)
            self.setBtnTabStyle(view: viewMesures)
       }
    
    func tabBarTint(imgSelect: UIImageView, imgs: [UIImageView], names: [String]){
        
        let image = UIImage(named: names[0])?.withRenderingMode(.alwaysTemplate)
        imgSelect.image = image
        imgSelect.tintColor = self.colorP
        
        var c = 1
        for img in imgs{
            let image = UIImage(named: names[c])?.withRenderingMode(.alwaysTemplate)
            img.image = image
            img.tintColor = UIColor.lightGray
            c += 1
        }
    }
    
    func setCleanViews(){
        for view in self.mainView.subviews {
            view.removeFromSuperview()
        }
    }
}

extension MainViewController: MainViewDelegate{
    
    func openBalance() {
        tabIncomes()
        self.setCleanViews()
        let controller3 = self.storyboard!.instantiateViewController(withIdentifier: "balance") as! BalanceViewController
        self.mainView.addSubview(controller3.view)
        self.addChild(controller3)
    }
    
    
    
}
