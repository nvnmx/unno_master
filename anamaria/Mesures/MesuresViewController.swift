//
//  MesuresViewController.swift
//  unno
//
//  Created by Bet Data Analysis on 21/07/20.
//  Copyright © 2020 nvn. All rights reserved.
//

import UIKit
import Parse

class MesuresViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    var citasList = [PFObject] ()
    
    lazy var viewControllerList: [UIViewController] = {
        
        let sb = UIStoryboard(name: "Main",bundle:nil)
        
        let vc1 = sb.instantiateViewController(withIdentifier:"medibles")
        
      //  let vc2 = sb.instantiateViewController(withIdentifier:"porciones")
        
        return [vc1]
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        obtenerCitasPaciente()
        
        
        
    }
    
    
    func obtenerCitasPaciente(){
        
        if let user = PFUser.current(){
            
            let query = PFQuery(className:"Appointment")
            query.whereKey("patient", equalTo: user)
            query.order(byDescending: "date")
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    // The request failed
                    print(error.localizedDescription)
                } else {
                    self.citasList.removeAll()
                    for pa:PFObject in objects!{
                        self.citasList.append(pa)
                    }
                    let  firstViewController = self.viewControllerList.first as! MediblesViewController
                    
                    firstViewController.citasList = self.citasList
                    self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
                    
                }
            }
            
        }
    }
    
    
   
    
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
       
        
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else { return nil}
        
        guard viewControllerList.count > previousIndex else { return nil}
        let viewController = viewControllerList[previousIndex]
        
        
        
        
        return viewController
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil}
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else { return nil}
        
        guard viewControllerList.count > nextIndex else { return nil}
        
        return viewControllerList[nextIndex]
        
        
        
        
    }
}
