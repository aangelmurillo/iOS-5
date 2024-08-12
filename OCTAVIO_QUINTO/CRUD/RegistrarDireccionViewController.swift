import UIKit

class RegistrarDireccionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var btnCrearUsuario: UIButton!
    @IBOutlet weak var txfCalle: UITextField!
    @IBOutlet weak var txfNumExterior: UITextField!
    @IBOutlet weak var txfNumInt: UITextField!
    @IBOutlet weak var txfCP: UITextField!
    @IBOutlet weak var txfColonia: UITextField!
    @IBOutlet weak var txfCiudad: UITextField!
    @IBOutlet weak var txfEstado: UITextField!
    @IBOutlet weak var txfPais: UITextField!
    
    var personData: PersonResponse?
    var user: UserResponse?
    var helmet: Helmet?
    
    var addressData: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserIdentifier()
        
        [txfCalle, txfNumExterior, txfNumInt, txfCP, txfColonia, txfCiudad, txfEstado, txfPais].forEach {
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        btnCrearUsuario.alpha = 0.5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkFields()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfCalle {
            txfNumExterior.becomeFirstResponder()
        } else if textField == txfNumExterior {
            txfNumInt.becomeFirstResponder()
        } else if textField == txfNumInt {
            txfCP.becomeFirstResponder()
        } else if textField == txfCP {
            txfColonia.becomeFirstResponder()
        } else if textField == txfColonia {
            txfCiudad.becomeFirstResponder()
        } else if textField == txfCiudad {
            txfEstado.becomeFirstResponder()
        } else if textField == txfEstado {
            txfPais.becomeFirstResponder()
        } else if textField == txfPais {
            textField.resignFirstResponder()
            crearNuevUsuario(btnCrearUsuario)
        }
        return true
    }
    
    func checkFields() {
        let fields = [txfCalle, txfNumExterior, txfCP, txfColonia, txfCiudad, txfEstado, txfPais]
        let allFieldsFilled = fields.allSatisfy { $0?.text?.isEmpty == false }
        
        btnCrearUsuario.isEnabled = allFieldsFilled
        btnCrearUsuario.alpha = allFieldsFilled ? 1.0 : 0.5
    }
    
    @IBAction func crearNuevUsuario(_ sender: UIButton) {
        guard let personData = personData else {
            print("Datos de la persona no encontrados")
            return
        }
        
        // Crear el diccionario con los datos de la dirección
        addressData = [
            "address_street": txfCalle.text ?? "",
            "address_exterior_number": txfNumExterior.text ?? "",
            "address_interior_number": txfNumInt.text?.isEmpty ?? true ? NSNull() : txfNumInt.text!,
            "address_neighborhood": txfColonia.text ?? "",
            "address_zip_code": txfCP.text ?? "",
            "address_city": txfCiudad.text ?? "",
            "address_state": txfEstado.text ?? "",
            "address_country": txfPais.text ?? "",
            "address_references": "",
            "person_id": personData.id
        ]
        
        if let addressData = self.addressData {
            ApiService.shared.postAddressData(addressData: addressData) { result in
                switch result {
                case .success(let addressResponse):
                    print("Dirección creada con éxito: \(addressResponse)")
                    
                    // Luego de crear la dirección, envía el código de verificación
                    if let user = self.user {
                        ApiService.shared.sendVerificationCode(email: user.email) { result in
                            switch result {
                            case .success(let verificationResponse):
                                print("Código de verificación enviado con éxito: \(verificationResponse)")
                                DispatchQueue.main.async {
                                    if let verificacionVC = self.storyboard?.instantiateViewController(withIdentifier: "VerificacionViewController") as? VerificacionViewController {
                                        verificacionVC.userResponse = user
                                        self.navigationController?.pushViewController(verificacionVC, animated: true)
                                    }
                                }
                            case .failure(let error):
                                print("No se pudo enviar el código de verificación: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                case .failure(let error):
                    print("No se pudo crear la dirección: \(error.localizedDescription)")
                }
            }
        }
    }

    @IBAction func cancelarCrearUsuario(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
