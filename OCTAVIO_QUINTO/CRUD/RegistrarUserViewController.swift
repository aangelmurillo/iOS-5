//
//  RegistrarUserViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 24/07/24.
//

import UIKit

class RegistrarUserViewController: UIViewController {

    @IBOutlet weak var viewR: UIView!
    @IBOutlet weak var btnAceptar: UIButton!
    @IBOutlet weak var lbluser: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbluser.adjustFontSize()
        btnAceptar.makeRoundButton(cornerRadius: 5)
        viewR.makeRoundView(cornerRadius: 5)

        configureCustomNavigationBar(title: "Ing. Octavio", subtitle: "octavio@gmail.com")
    }
    
    
    
    
    @IBAction func cancelarCrearUsuario(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
