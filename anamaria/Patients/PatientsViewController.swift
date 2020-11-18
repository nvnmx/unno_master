//
//  PatientsViewController.swift
//  anamaria
//
//  Created by Francisco on 12/17/18.
//  Copyright © 2018 nvn. All rights reserved.
//

import UIKit
import Parse

class PatientsViewController: UIViewController, UISearchBarDelegate,AddPatientViewControllerProtocol {
    
    
    
    struct Objects {
        var name : String
        var patients = [PFObject]()
    }
    
    @IBOutlet weak var lblNoSearch: UILabel!
    var patientsGroup = [Objects] ()
    var patients = [Objects] ()
    
    @IBOutlet weak var patientsTable: UITableView!
    @IBOutlet weak var patiensSearch: UISearchBar!
    
    var searchActive : Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getPatients()
    }
    @IBAction func btnNuevoPaciente(_ sender: Any) {
        nuevoPaciente()
    }
    
    func nuevoPaciente()
       {
           let destination = self.storyboard?.instantiateViewController(withIdentifier: "AddPatientViewController") as! AddPatientViewController
           destination.delegateNuevoPaciente = self
                      self.show(destination, sender: nil)
       }
    
    func actualizarInfo() {
         getPatients()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PatientsViewController.dissmisKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func getPatients(){
        self.patientsGroup = [Objects]()
        self.patients = [Objects]()
        
        let query_novedades = PFUser.query()!
        query_novedades.order(byAscending: "name")
        query_novedades.whereKey("typeUser", equalTo: "patient")
         query_novedades.whereKey("nutritionist", equalTo: PFUser.current())
        
        query_novedades.findObjectsInBackground { (objects, error) in
            
            if(error == nil ){
                var section: [String] = []
                var auxiliarOrdenar = [PFObject] ()
                
                for pa:PFObject in objects!{
                    if let nombreInicial = pa.value(forKey: "name") as? String{
                        if auxiliarOrdenar.count == 0
                        {
                            auxiliarOrdenar.append(pa)
                        }
                        else
                        {
                            var cont = 0
                            var insertado = false
                            for aux:PFObject in auxiliarOrdenar {
                                if let nombreRecorriendo = aux.value(forKey: "name") as? String{
                                    let resComp = nombreInicial.compare(nombreRecorriendo, options: NSString.CompareOptions.caseInsensitive)
                                    if resComp == .orderedAscending
                                    {
                                        auxiliarOrdenar.insert(pa, at: cont)
                                        insertado = true
                                        break
                                    }
                                    cont = cont + 1
                                }
                            }
                            if !insertado
                            {
                                auxiliarOrdenar.append(pa)
                            }
                        }
                    }
                }
                
                for pa:PFObject in auxiliarOrdenar{
                    if let name = pa.value(forKey: "name") as? String{
                        if let lastname = pa.value(forKey: "lastName") as? String{
                            let finalName = "\(name) \(lastname)"
                            var headerChar = "\(finalName[finalName.index(finalName.startIndex, offsetBy: 0)])"
                            headerChar = headerChar.uppercased()
                            if(!section.contains(headerChar)){
                                section.append(headerChar)
                                self.patientsGroup.append(Objects(name: headerChar, patients: self.getSetions(patients: objects!, tittle: headerChar)))
                            }
                        }
                    }
                }
                
                self.patients = self.patientsGroup
                self.patientsTable.reloadData()
            }
        }
    }
    
    func getSetions(patients : [PFObject], tittle: String) -> [PFObject] {
        
        var count = 0
        var pac:[PFObject] = [PFObject]()
        
        for paciente in patients{
            count = count + 1
            
            if let header = paciente.value(forKey: "name") as? String{
                let headerChar = "\(header[header.index(header.startIndex, offsetBy: 0)])"
                
                if(headerChar == tittle || headerChar.uppercased() == tittle){
                    pac.append(paciente)
                }
            }
        }
        return pac
    }
    
    func newSetions(patients : [PFObject], tittle: String,filter: String) -> [PFObject] {
        
        var count = 0
        var pac:[PFObject] = [PFObject]()
        
        for paciente in patients{
            count = count + 1
            
            if let header = paciente.value(forKey: "name") as? String{
                if let lastName = paciente.value(forKey: "lastName") as? String{
                    let finalName = "\(header) \(lastName)"
                    let headerChar = "\(finalName[finalName.index(finalName.startIndex, offsetBy: 0)])"
                    
                    if(headerChar.lowercased() == tittle.lowercased()){
                        if(finalName.lowercased().contains(filter.lowercased())){
                            pac.append(paciente)
                        }
                    }
                }
            }
        }
        return pac
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    @objc func dissmisKeyboard(){
        view.endEditing(true)
    }
    
    
   
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        if(searchText == ""){
            self.lblNoSearch.isHidden = true
            self.patientsTable.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            self.patientsGroup = self.patients
        }else{
            var pacNew:[Objects] = [Objects]()
            for paciente in self.patients{
                
                let obj = self.newSetions(patients: paciente.patients , tittle: paciente.name, filter: searchText)
                if(obj.count != 0){
                    pacNew.append(Objects(name: paciente.name, patients: obj))
                }
            }
            
            if(pacNew.count == 0){
                self.lblNoSearch.isHidden = false
                self.patientsTable.separatorStyle = UITableViewCell.SeparatorStyle.none
            }else{
                self.lblNoSearch.isHidden = true
                self.patientsTable.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            }
            
            self.patientsGroup = pacNew
        }
        patientsTable.reloadData()
    }
    
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        dissmisKeyboard()
        self.patientsTable.reloadData()
    }
    
    
}


extension PatientsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.patientsGroup.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.patientsGroup[section].name)_"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderNotification.createMyClassView()
        header.lblTitle.text = "\(self.patientsGroup[section].name)_"
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patientsGroup[section].patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientsCell", for: indexPath) as! PatientsTableViewCell
        
        let nov = self.patientsGroup[indexPath.section].patients[indexPath.row]
        
        if let name = nov.value(forKey: "name") as? String{
            if let last = nov.value(forKey: "lastName") as? String{
                cell.name.text = "\(name) \(last)"
            }
        }
        
        if let isTutor = nov.value(forKey: "isTutor") as? Bool{
            if(isTutor){
                cell.isTutor.isHidden = false
            }else{
                cell.isTutor.isHidden = true
            }
        }else{
            cell.isTutor.isHidden = true
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.onButtonTapped = {
            
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            destination.pacienteUser = (nov as! PFUser)
            self.show(destination, sender: nil)
            
        }
        
        return cell
    }
    
    
    enum NSComparasionResult : Int {
        case OrderedAscending
        case OrderedSame
        case OrderedDescending
    }
    
}
