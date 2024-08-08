//
//  RegistrarDireccionViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Adrian Gottfried on 07/08/24.
//

import UIKit

class RegistrarDireccionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func crearNuevUsuario(_ sender: UIButton) {
        showAlert(title: "Éxito", message: "Usuario creado con éxito") {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func cancelarCrearUsuario(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
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
