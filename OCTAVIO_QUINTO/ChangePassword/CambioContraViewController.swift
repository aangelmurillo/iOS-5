//
//  CambioContraViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 24/07/24.
//

import UIKit

class CambioContraViewController: UIViewController {

    @IBOutlet weak var btnEn: UIButton!
    @IBOutlet weak var viewCon: UIView!
    @IBOutlet weak var lblCambioC: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEn.makeRoundButton(cornerRadius: 5)
        viewCon.makeRoundView(cornerRadius: 5)
        
        lblCambioC.adjustFontSize()
    }
    
    @IBAction func confirmarNuevaContraseña(_ sender: UIButton) {
        showAlert(title: "Éxito", message: "Nueva contraseña creada") {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
