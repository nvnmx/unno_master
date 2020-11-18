//
//  HeaderNotification.swift
//  anamaria
//
//  Created by ArturoGR on 8/18/19.
//  Copyright © 2019 nvn. All rights reserved.
//

import UIKit

class HeaderNotification: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var heigt: NSLayoutConstraint!
    
    
    class func createMyClassView() -> HeaderNotification {
        let myClassNib = UINib(nibName: "HeaderNotification", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! HeaderNotification
    }
    
}
