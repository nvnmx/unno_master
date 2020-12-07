//
//  Utils.swift
//  anamaria
//
//  Created by Francisco on 12/2/18.
//  Copyright © 2018 nvn. All rights reserved.
//

import Foundation

import UIKit
//import GoogleMaps
import Parse
//import SwiftLocation
//import MapKit


class Utils : UIViewController{
}

extension UIViewController{
    
    
    
    func getTypeUser() -> Bool{
        
        if let user = PFUser.current(){
                if let typeUser = user.object(forKey: "typeUser") as? String{
                    if(typeUser == "patient"){
                         return true
                    }else{
                         return false
                    }
                  }else{
                       return false
                  }
              }
        
        return false
    }
    
    func doubletoString(_ price: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: price as NSNumber)!
    }
    
    
    func fechaStartDay(date: Date)->Date
    {
        
        let conUnDiaMas = Calendar.current.date(byAdding: .day, value: 1, to: date)
     
        let calendar = Calendar.current
        let startTime = calendar.startOfDay(for: conUnDiaMas!)
        
        return startTime
        
    }
    
    
    func regresarFecha(date: Date)->Date
    {
        
        let conUnDiaMenos = Calendar.current.date(byAdding: .day, value: -1, to: date)
     
        let calendar = Calendar.current
        let startTime = calendar.startOfDay(for: conUnDiaMenos!)
        
        return startTime
        
    }
    
   
    
    func createAlert(title: String, message: String) {
        
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alertC.addAction(OKAction)
        
        self.present(alertC, animated: true)
    }
    
    func setBtnTabStyle(view : UIView){
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.shadowColor = UIColor(red:0.44, green:0.31, blue:0.85, alpha:1).cgColor
        view.layer.shadowOpacity =  0.3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 8
        view.layer.cornerRadius = view.frame.size.width / 2
        view.clipsToBounds = true
    }
    
    func setBtnStyle(view : UIView){
        view.layer.borderColor = UIColor(red:0.44, green:0.31, blue:0.85, alpha:1.0).cgColor
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 2.3
    }
    
    
    func setBtnTabStyleSelected(view : UIView){
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.shadowColor = UIColor(red:0.51, green:0.40, blue:0.89, alpha:1.0).cgColor
        view.layer.shadowOpacity =  0.3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = view.frame.size.width / 2
        view.clipsToBounds = true
    }
    
    func setCardStyle(view : UIView){
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor(red:0.29, green:0.29, blue:0.40, alpha:1.0).cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6.5
    }
   
    
    
    
    func setCollectionStyle(view : UIView){
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor(red:0.29, green:0.29, blue:0.40, alpha:1.0).cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 8
    }
  
    
    
    
    func setCollectionStyleSelect(view : UIView){
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor(red:0.29, green:0.29, blue:0.40, alpha:1.0).cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 8
        view.backgroundColor = UIColor(red:0.44, green:0.31, blue:0.85, alpha:1)
    }
    
    func setCardStyleBtn(view : UIView){
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor(red:0.29, green:0.29, blue:0.40, alpha:1.0).cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 8
    }
    
    func setCardStyleTwo(view : UIView){
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor(red:0.29, green:0.29, blue:0.40, alpha:1.0).cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 8
    }
    
    func createAlertDismiss(title: String, message: String) {
        
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertC.addAction(OKAction)
        
        self.present(alertC, animated: true)
    }
    
    func createAlertLogIn(title: String, message: String) {
        
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            //let log = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LogInViewController
            //self.show(log, sender: nil)
        }
        alertC.addAction(OKAction)
        
        self.present(alertC, animated: true)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
            + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func callPhone(phone : String){
        guard let number = URL(string: "telprompt://" + phone) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    /*func getLocation(map: GMSMapView,locationManager : CLLocationManager){
        
        /*Locator.currentLocation(accuracy: .block, frequency: .oneShot, success: {(_,location) in
         
         map.camera = GMSCameraPosition(target: location.coordinate, zoom: 11, bearing: 0, viewingAngle: 0)
         
         map.isMyLocationEnabled = true
         
         locationManager.stopUpdatingLocation()
         
         
         }){ (request,last, error) in
         request.cancel()
         print(error)
         }*/
        Locator.currentPosition(accuracy: .block, onSuccess: { (location) -> (Void) in
            map.camera = GMSCameraPosition(target: location.coordinate, zoom: 11, bearing: 0, viewingAngle: 0)
            
            map.isMyLocationEnabled = true
            
            locationManager.stopUpdatingLocation()
        }) { (req, last) -> (Void) in
            
            print(req.localizedDescription)
        }
        
    }
    
    func openMapForPlace(location:PFGeoPoint, name : String) {
        
        let latitude: CLLocationDegrees = location.latitude
        let longitude: CLLocationDegrees = location.longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        
        mapItem.openInMaps(launchOptions: options)
    }*/
    
    
    func makeNavigationBarInvisible(){
        let navBar = self.navigationController?.navigationBar
        if navBar != nil{
            navBar!.setBackgroundImage(UIImage(), for: .default)
            navBar!.shadowImage = UIImage()
            navBar!.isTranslucent = true
        }
    }
    
    func makeNavigationBarVisible(){
        let navBar = self.navigationController?.navigationBar
        if navBar != nil{
            navBar!.setBackgroundImage(nil, for: .default)
            navBar!.shadowImage = UIImage()
            navBar!.isTranslucent = true
        }
    }
    
}

extension UIImage {

    func resize(maxWidthHeight : Double)-> UIImage? {

        let actualHeight = Double(size.height)
        let actualWidth = Double(size.width)
        var maxWidth = 0.0
        var maxHeight = 0.0

        if actualWidth > actualHeight {
            maxWidth = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualWidth)
            maxHeight = (actualHeight * per) / 100.0
        }else{
            maxHeight = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualHeight)
            maxWidth = (actualWidth * per) / 100.0
        }

        let hasAlpha = true
        let scale: CGFloat = 0.0

        UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: maxHeight), !hasAlpha, scale)
        self.draw(in: CGRect(origin: .zero, size: CGSize(width: maxWidth, height: maxHeight)))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }

}
