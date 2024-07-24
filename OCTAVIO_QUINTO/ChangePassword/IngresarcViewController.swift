//
//  IngresarcViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 24/07/24.
//

import UIKit

class IngresarcViewController: UIViewController {

    @IBOutlet weak var btnEnvi: UIButton!
    @IBOutlet weak var viewEm: UIView!
    @IBOutlet weak var lblBreve: UILabel!
    @IBOutlet weak var lblIngresar: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblBreve.adjustFontSize()
        lblIngresar.adjustFontSize()
        btnEnvi.makeRoundButton(cornerRadius: 5)
        viewEm.makeRoundView(cornerRadius: 5)

        // Do any additional setup after loading the view.
    }
}
