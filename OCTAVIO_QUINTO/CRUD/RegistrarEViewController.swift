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
        
        configureCustomNavigationBar(title: "Ing. Octavio", subtitle: "octavio@gmail.com")
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
