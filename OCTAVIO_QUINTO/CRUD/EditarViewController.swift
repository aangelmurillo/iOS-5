//
//  EditarViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 24/07/24.
//

import UIKit

class EditarViewController: UIViewController {

    @IBOutlet weak var btnAcept: UIButton!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var lblEditar: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblEditar.adjustFontSize()
        btnAcept.makeRoundButton(cornerRadius: 5)
        viewEdit.makeRoundView(cornerRadius: 5)

       
        configureCustomNavigationBar(title: "Ing. Octavio", subtitle: "octavio@gmail.com")
    }
    

    @IBAction func BtnAceptar(_ sender: UIButton) {
        showAlert(title: "Éxito", message: "Usuario editado exitosamente") {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        
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
