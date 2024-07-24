//
//  CodigoViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 24/07/24.
//

import UIKit

class CodigoViewController: UIViewController {

    @IBOutlet weak var btnCon: UIButton!
    @IBOutlet weak var viewC: UIView!
    @IBOutlet weak var lblCodigo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewC.makeRoundView(cornerRadius: 5)
        btnCon.makeRoundButton(cornerRadius: 5)
        

        lblCodigo.adjustFontSize()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
