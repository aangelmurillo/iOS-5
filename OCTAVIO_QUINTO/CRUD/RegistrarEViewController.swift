//
//  RegistrarEViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 23/07/24.
//

import UIKit

class RegistrarEViewController: UIViewController {

    @IBOutlet weak var viewR: UIView!
    @IBOutlet weak var btnAcep: UIButton!
    @IBOutlet weak var lblRegistrar: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblRegistrar.adjustFontSize()
        btnAcep.makeRoundButton(cornerRadius: 5)
        viewR.makeRoundView(cornerRadius: 5)
        
        fetchUserIdentifier()
    }

}
