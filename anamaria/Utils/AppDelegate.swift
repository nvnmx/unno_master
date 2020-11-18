//
//  AppDelegate.swift
//  anamaria
//
//  Created by Francisco on 10/7/18.
//  Copyright © 2018 nvn. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "SSJ50Dg9SSeBhqGAWqCoWjizduLx1tSO8cKO9hD3"
            $0.clientKey = "nhywjrECsEa6ZT1BO0289EKPBwFJmOEDZ5AsfAE0"
            $0.server = "https://unno.fit/parse"
        }
    
        
        Parse.initialize(with: configuration)
        
        
        if(PFUser.current() != nil){
           // let storyboard = UIStoryboard(name: "Main", bundle: nil)
           // let destination = storyboard.instantiateViewController(withIdentifier: "main")
           // self.window?.rootViewController = destination
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "main")
            
            
         //   self.window?.makeKeyAndVisible()
            
            /**
             let destination = self.storyboard!.instantiateViewController(withIdentifier: "main")
                                        destination.modalPresentationStyle = .fullScreen
                                        self.show(destination, sender: nil)
 */
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
   
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      
    }

    func applicationWillTerminate(_ application: UIApplication) {
     
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let installation = PFInstallation.current()
        installation!.setDeviceTokenFrom(deviceToken)
        installation!.saveInBackground()
    }

}

