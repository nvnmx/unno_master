//
//  MesuresViewController.swift
//  unno
//
//  Created by Bet Data Analysis on 21/07/20.
//  Copyright © 2020 nvn. All rights reserved.
//

import UIKit
import Parse

class SwipeViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    
    lazy var viewControllerList: [UIViewController] = {
        
        let sb = UIStoryboard(name: "Main",bundle:nil)
        
        let vc1 = sb.instantiateViewController(withIdentifier:"porciones")
        
        let vc2 = sb.instantiateViewController(withIdentifier:"alimentos")
        
        return [vc1,vc2]
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
      let  firstViewController = self.viewControllerList.first as! PorcionesViewController
        
       
        self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        
        
        
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
