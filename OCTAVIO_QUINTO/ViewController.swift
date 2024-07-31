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
    
    /*@objc func loginTapped() {
        // Aquí llamarías tu lógica de autenticación real
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.userDidLogin()
        }
    }*/
    
    @objc func loginTapped() {
        guard let user = txfIdentificador.text, !user.isEmpty,
              let password = txfContraseña.text, !password.isEmpty else {
            print("Usuario o contraseña vacíos")
            return
        }

        let url = URL(string: "http://3.138.244.45/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["user": user, "password": password]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error al serializar los parámetros: \(error.localizedDescription)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la solicitud: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta inesperada del servidor.")
                return
            }

            if httpResponse.statusCode != 200 {
                print("Error de autenticación: \(httpResponse.statusCode)")
                if let data = data {
                    print("Datos de error recibidos: \(String(data: data, encoding: .utf8) ?? "Datos vacíos")")
                }
                return
            }

            guard let data = data else {
                print("Datos de respuesta vacíos.")
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Respuesta del servidor: \(jsonResponse)")
                    
                    if let tokenDict = jsonResponse["token"] as? [String: Any],
                       let token = tokenDict["token"] as? String {
                        UserDefaults.standard.set(token, forKey: "authToken")
                        
                        if let userDict = jsonResponse["user"] as? [String: Any],
                           let userId = userDict["id"] as? Int {
                            UserDefaults.standard.set(userId, forKey: "userId")
                            
                            if let usuario = Usuario.from(json: userDict) {
                                if let encodedUser = try? JSONEncoder().encode(usuario) {
                                    UserDefaults.standard.set(encodedUser, forKey: "loggedUser")
                                }
                            }
                            
                            DispatchQueue.main.async {
                                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                                    sceneDelegate.userDidLogin()
                                }
                            }
                        } else {
                            print("Error: El campo 'user' no está presente o no contiene un 'id'.")
                        }
                    } else {
                        print("Error: El campo 'token' no está presente o no contiene un token.")
                    }
                }
            } catch {
                print("Error al parsear la respuesta JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

}

