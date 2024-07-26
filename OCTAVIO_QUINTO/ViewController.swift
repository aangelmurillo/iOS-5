//
//  ViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 18/06/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewLogo: UIView!
    @IBOutlet weak var lblBienvenido: UILabel!
    @IBOutlet weak var btnIngresar: UIButton!
    @IBOutlet weak var txfIdentificador: UITextField!
    @IBOutlet weak var txfContraseña: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblBienvenido.adjustFontSize()
        btnIngresar.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        viewLogo.makeRoundView()
        btnIngresar.makeRoundButton(cornerRadius: 15.0) // btnIngresar modifica el tamaño de lblBienvenido cada que se pulsa
        
    }
    
    @objc func loginTapped() {
        // Aquí llamarías tu lógica de autenticación real
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.userDidLogin()
        }
    }
}

