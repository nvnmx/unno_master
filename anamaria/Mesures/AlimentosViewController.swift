//
//  AlimentosViewController.swift
//  unno
//
//  Created by Bet Data Analysis on 22/09/20.
//  Copyright © 2020 nvn. All rights reserved.
//

import UIKit

struct CellData {
    
    var open = Bool()
    var titulo = String()
    var sectionData = [Alimento]()
    var color = UIColor()
    
    
}

struct Alimento {
    var nombre = String ()
    var tazas = String ()
    
}

class AlimentosViewController: UITableViewController {

    var datosAlimentos = [CellData]()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        datosAlimentos = [CellData(open: false, titulo: "VERDURAS", sectionData: [Alimento(nombre: "Acelgas crudas", tazas: "2 tazas"),Alimento(nombre: "Alcachofa cocida", tazas: "1 pieza"),Alimento(nombre: "Apio", tazas: "1 1/2 taza"),Alimento(nombre: "Arúgula", tazas: "4 tazas"),Alimento(nombre: "Betabel crudo rallado", tazas: "1/4 taza"),Alimento(nombre: "Brócoli Cocido", tazas: "1/2 taza"),Alimento(nombre: "Calabacita", tazas: "1 pieza"),Alimento(nombre: "Cebolla", tazas: "1/2 taza"),Alimento(nombre: "Champiñones Cocidos", tazas: "1/2 taza"),Alimento(nombre: "Chayote", tazas: "1/2 taza"),Alimento(nombre: "Chícharo", tazas: "1/2 taza"),Alimento(nombre: "Chile", tazas: "3 piezas"),Alimento(nombre: "Cilantro", tazas: "2 tazas"),Alimento(nombre: "Col", tazas: "1 taza"),Alimento(nombre: "Coliflor", tazas: "1 taza"),Alimento(nombre: "Ejotes", tazas: "1/2 taza"),Alimento(nombre: "Espárragos", tazas: "6 piezas"),Alimento(nombre: "Espinaca", tazas: "2 tazas"),Alimento(nombre: "Gérmen de Soya", tazas: "1/3 taza"),Alimento(nombre: "Jícama", tazas: "1/2 taza"),Alimento(nombre: "Jitomate", tazas: "1 pieza"),Alimento(nombre: "Lechuga", tazas: "3 tazas"),Alimento(nombre: "Nopal", tazas: "2 piezas"),Alimento(nombre: "Pepino", tazas: "1 taza"),Alimento(nombre: "Pimiento", tazas: "1 pieza"),Alimento(nombre: "Setas", tazas: "1/2 taza"),Alimento(nombre: "Zanahoria", tazas: "1/2 taza")], color:UIColor(hexFromString: "ACB66F")),CellData(open: false, titulo: "LEGUMINOSAS", sectionData: [Alimento(nombre: "Frijoles Cocidos", tazas: "1/2 taza"),Alimento(nombre: "Garbanzos Cocidos", tazas: "1/2 taza"),Alimento(nombre: "Habas Cocidas", tazas: "1/2 taza"),Alimento(nombre: "Hummus", tazas: "5 cucharadas"),Alimento(nombre: "Lentejas Cocidas", tazas: "1/2 taza"),Alimento(nombre: "Soya cocida", tazas: "1/3 taza")], color:UIColor(hexFromString: "7A4541")),CellData(open: false, titulo: "LÁCTEOS", sectionData: [Alimento(nombre: "Leche de Soya", tazas: "1 taza"),Alimento(nombre: "Leche Descremada / Light", tazas: "1 taza"),Alimento(nombre: "Yogurt natural", tazas: "3/4 taza")], color:UIColor(hexFromString: "5990BF")),CellData(open: false, titulo: "FRUTAS", sectionData: [Alimento(nombre: "Caña de azúcar", tazas: "250 g"),Alimento(nombre: "Carambolo", tazas: "1 1/2 pieza"),Alimento(nombre: "Ciruela roja", tazas: "3 piezas"),Alimento(nombre: "Durazno", tazas: "2 piezas"),Alimento(nombre: "Frambuesas", tazas: "1 taza"),Alimento(nombre: "Fresas", tazas: "17 piezas"),Alimento(nombre: "Granada china", tazas: "2 piezas"),Alimento(nombre: "Granada roja", tazas: "1 pieza"),Alimento(nombre: "Guayaba", tazas: "3 piezas"),Alimento(nombre: "Higo", tazas: "2 piezas"),Alimento(nombre: "Jugo de Naranja Nat", tazas: "1/2 taza"),Alimento(nombre: "Kiwi", tazas: "1 1/2 piezas"),Alimento(nombre: "Lichis", tazas: "12 piezas"),Alimento(nombre: "Lima", tazas: "3 piezas"),Alimento(nombre: "Mamey", tazas: "1/3 pieza"),Alimento(nombre: "Mandarina", tazas: "1 pieza"),Alimento(nombre: "Mango", tazas: "1 pieza"),Alimento(nombre: "Manzana", tazas: "1 pieza"),Alimento(nombre: "Maracuyá", tazas: "3 piezas"),Alimento(nombre: "Melón", tazas: "1 taza"),Alimento(nombre: "Naranja", tazas: "2 piezas"),Alimento(nombre: "Papaya", tazas: "1 taza"),Alimento(nombre: "Pasas", tazas: "10 piezas"),Alimento(nombre: "Pera", tazas: "1/2 pieza"),Alimento(nombre: "Piña", tazas: "3/4 taza"),Alimento(nombre: "Plátano", tazas: "1/2 taza"),Alimento(nombre: "Sandía", tazas: "1 taza"),Alimento(nombre: "Tamarindo", tazas: "50 g"),Alimento(nombre: "Toronja", tazas: "1 pieza"),Alimento(nombre: "Tuna", tazas: "2 piezas"),Alimento(nombre: "Uva", tazas: "18 piezas")],color:UIColor(hexFromString: "E0A273")),
                          CellData(open: false, titulo: "CEREALES", sectionData: [
                            Alimento(nombre: "Amaranto", tazas: "1/4 taza"),
                            Alimento(nombre: "Arroz", tazas: "1/2 taza"),
                            Alimento(nombre: "Avena", tazas: "1/2 taza"),
                            Alimento(nombre: "Bagel", tazas: "1/2 pieza"),
                            Alimento(nombre: "Barquillo", tazas: "1 1/2 pieza"),
                            Alimento(nombre: "Barra integral comercial", tazas: "1 pieza"),
                            Alimento(nombre: "Bolillo integral", tazas: "1/3 pieza"),
                            Alimento(nombre: "Bollo para hamburguesa", tazas: "1/3 pieza"),
                            Alimento(nombre: "Camote", tazas: "1/3 pieza"),
                            Alimento(nombre: "Cereal Integral Comercial", tazas: "1/2 taza"),
                            Alimento(nombre: "Crepas", tazas: "2 piezas"),
                            Alimento(nombre: "Croissant / Cuernito", tazas: "1/2 pieza"),
                            Alimento(nombre: "Crutones", tazas: "1/2 taza"),
                            Alimento(nombre: "Elote Cocido", tazas: "1 1/2 pieza"),
                            Alimento(nombre: "Elote Desgranado", tazas: "1/2 taza"),
                            Alimento(nombre: "Espaguetti", tazas: "1/2 taza"),
                            Alimento(nombre: "Galletas de animalitos", tazas: "6 piezas"),
                            Alimento(nombre: "Galletas Marías", tazas: "5 piezas"),
                            Alimento(nombre: "Galletas Saladas", tazas: "8 cuadritos"),
                            Alimento(nombre: "Galletas Habaneras", tazas: "4 piezas"),
                            Alimento(nombre: "Galletas Integrales Comerciales", tazas: "3 piezas"),
                            Alimento(nombre: "Hot Cakes Medianos", tazas: "1 pieza"),
                            Alimento(nombre: "Media Noche", tazas: "1/2 pieza"),
                            Alimento(nombre: "Palomitas Naturales", tazas: "2 1/2 tazas"),Alimento(nombre: "Pan Integral o tostado", tazas: "1 pieza"),
                            Alimento(nombre: "Papa cocida grande", tazas: "1/2 pieza"),Alimento(nombre: "Pasta (Sopa)", tazas: "1/2 taza"),
                            Alimento(nombre: "Puré de papa", tazas: "1/3 taza"),Alimento(nombre: "Quinoa", tazas: "1/4 taza"),
                            Alimento(nombre: "Tapioca", tazas: "2 cucharadas"),Alimento(nombre: "Tortilla de maíz", tazas: "1 pieza"),
                            Alimento(nombre: "Tortilla de nopal", tazas: "2 piezas"),Alimento(nombre: "Tortilla de Harina Integral", tazas: "1 pieza"),
                            Alimento(nombre: "Tostada de maíz", tazas: "2 piezas"),Alimento(nombre: "Tostada de nopal", tazas: "2 piezas")], color:UIColor(hexFromString: "E3CD5A")),CellData(open: false, titulo: "ALIMENTOS DE ORIGEN ANIMAL", sectionData: [
                                Alimento(nombre: "Atún en agua", tazas: "1/2 lata"),
                            Alimento(nombre: "Arrachera", tazas: "30 g"),
                            Alimento(nombre: "Bistec de res", tazas: "30 g"),
                            Alimento(nombre: "Camarón", tazas: "5 piezas"),
                            Alimento(nombre: "Carne Molida", tazas: "30 g"),
                            Alimento(nombre: "Cecina", tazas: "25 g"),
                            Alimento(nombre: "Chuleta Ahumada", tazas: "1/2 pieza"),
                            Alimento(nombre: "Filete de pescado", tazas: "40 g"),
                            Alimento(nombre: "Huevo", tazas: "1 pieza"),
                            Alimento(nombre: "Jamón de Pavo", tazas: "2 rebanadas"),
                            Alimento(nombre: "Pavo", tazas: "45 g"),
                            Alimento(nombre: "Pechuga de Pollo", tazas: "30 g"),
                            Alimento(nombre: "Queso Cottage", tazas: "1/4 taza"),
                            Alimento(nombre: "Queso Manchego", tazas: "25 g"),
                            Alimento(nombre: "Queso Panela", tazas: "40 g"),
                            Alimento(nombre: "Queso Oaxaca", tazas: "30 g"),
                            Alimento(nombre: "Salchicha de Pavo", tazas: "1 pieza"),
                            Alimento(nombre: "Salmón", tazas: "35 g")], color:UIColor(hexFromString: "C86466")),CellData(open: false, titulo: "GRASAS", sectionData: [Alimento(nombre: "Aceite (varios)", tazas: "1 cucharada # 3"),
                            Alimento(nombre: "Aceite en spray", tazas: "5 disparos de un segundo"),
                            Alimento(nombre: "Aceitunas", tazas: "5 piezas"),
                            Alimento(nombre: "Aderezo", tazas: "3 cucharadas # 3"),
                            Alimento(nombre: "Aguacate", tazas: "1/3 pieza"),
                            Alimento(nombre: "Coco", tazas: "1/4 pieza"),
                            Alimento(nombre: "Crema Light", tazas: "5 cucharadas # 3"),
                            Alimento(nombre: "Mayonesa", tazas: "1 cucharada # 3"),
                            Alimento(nombre: "Queso Crema", tazas: "2 cucharadas # 3")], color:UIColor(hexFromString: "E0B75B")), CellData(open: false, titulo: "GRASAS CON PROTEÍNA", sectionData: [
                                Alimento(nombre: "Ajonjolí", tazas: "4 cucharadas # 3"),
                            Alimento(nombre: "Almendra", tazas: "10 piezas"),
                            Alimento(nombre: "Cacahuate", tazas: "14 piezas"),
                            Alimento(nombre: "Chía", tazas: "7 cucharadas"),
                            Alimento(nombre: "Jamón Serrano", tazas: "15 g"),
                            Alimento(nombre: "Mantequilla de Cacahuate", tazas: "2 cucharadas # 3"),
                            Alimento(nombre: "Nueces", tazas: "6 piezas"),
                            Alimento(nombre: "Nuez de la India", tazas: "7 piezas"),
                            Alimento(nombre: "Pepitas", tazas: "1 cucharada # 3"),
                            Alimento(nombre: "Piñón", tazas: "1 cucharada # 3"),
                            Alimento(nombre: "Pistache", tazas: "18 piezas"),
                            Alimento(nombre: "Queso de Puerco", tazas: "20 g")], color:UIColor(hexFromString: "B7AEBF")),CellData(open: false, titulo: "AZÚCARES", sectionData: [
                                Alimento(nombre: "Azúcares de mesa", tazas: "2 cucharadas # 3"),
                            Alimento(nombre: "Cajeta", tazas: "1.5 cucharadas # 3"),
                            Alimento(nombre: "Gelatina", tazas: "1/3 taza"),
                            Alimento(nombre: "Mermelada", tazas: "2.5 cucharadas # 3")], color:UIColor(hexFromString: "944149")),CellData(open: false, titulo: "ALIMENTOS LIBRES", sectionData: [
                                Alimento(nombre: "Vinagre", tazas: ""),
                            Alimento(nombre: "Agua Mineral", tazas: ""),
                            Alimento(nombre: "Ajo", tazas: ""),
                            Alimento(nombre: "Alcaparras", tazas: ""),
                            Alimento(nombre: "Albahaca", tazas: ""),
                            Alimento(nombre: "Café", tazas: ""),
                            Alimento(nombre: "Caldos (varios)", tazas: ""),
                            Alimento(nombre: "Especias", tazas: ""),
                            Alimento(nombre: "Jamaica", tazas: ""),
                            Alimento(nombre: "Gelatina Light", tazas: ""),
                            Alimento(nombre: "Hierbabuena", tazas: ""),
                            Alimento(nombre: "Limón", tazas: ""),
                            Alimento(nombre: "Té (varios)", tazas: ""),
                            Alimento(nombre: "Menta", tazas: ""),
                            Alimento(nombre: "Canela", tazas: ""),
                            Alimento(nombre: "Cebolla", tazas: ""),
                            Alimento(nombre: "Chicle sin azúcar", tazas: ""),
                            Alimento(nombre: "Chiles (varios)", tazas: ""),
                            Alimento(nombre: "Sal", tazas: ""),
                            Alimento(nombre: "Salsa Inglesa", tazas: ""),
                            Alimento(nombre: "Salsa de Soya", tazas: "")], color:UIColor(hexFromString: "E6CC57") ),CellData(open: false, titulo: "CONSEJOS", sectionData: [
                                Alimento(nombre: "Prefiere siempre lo integral y elimina lo refinado", tazas: "Mastica lo más que puedas tus alimentos y trata de comer despacio"),
                            Alimento(nombre: "Evita las grasas saturadas y los alimentos fritos", tazas: "Disminuye la cantidad de irritantes y alcohol"),
                            Alimento(nombre: "Duerme mínimo 7 horas diarias por la noche", tazas: "Disfruta tus alimentos y saboréalos"),
                            Alimento(nombre: "Concéntrate en tus platillos y retira cualquier distractor a la hora de comer", tazas: "Realiza el ejercicio recomendado"),
                            Alimento(nombre: "Evita al máximo los alimentos procesados", tazas: "")], color:UIColor(hexFromString: "6A3444"))]
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return datosAlimentos.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datosAlimentos[section].open
        {
            return datosAlimentos[section].sectionData.count + 1
        }
        else
        {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell()
            }
            cell.textLabel?.text = datosAlimentos[indexPath.section].titulo
            cell.backgroundColor = datosAlimentos[indexPath.section].color
            return cell
        }
        else
        {
            
          
             let cell = Bundle.main.loadNibNamed("PorcionTableViewCell", owner: self, options: nil)?.first as! PorcionTableViewCell
            cell.lblAlimento.text = datosAlimentos[indexPath.section].sectionData[indexPath.row - 1].nombre
            cell.lblTazas.text = datosAlimentos[indexPath.section].sectionData[indexPath.row - 1].tazas
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if datosAlimentos[indexPath.section].open
        {
            datosAlimentos[indexPath.section].open = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: UITableView.RowAnimation.fade)
        }
        else
        {
          datosAlimentos[indexPath.section].open = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: UITableView.RowAnimation.fade)
        }
    }
    
    
}

extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
