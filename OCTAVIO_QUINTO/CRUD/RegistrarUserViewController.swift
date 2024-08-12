import UIKit

class RegistrarUserViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewR: UIView!
    @IBOutlet weak var btnAceptar: UIButton!
    @IBOutlet weak var lbluser: UILabel!
    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfConfirmarContraseña: UITextField!
    @IBOutlet weak var segRol: UISegmentedControl!
    @IBOutlet weak var txfCasco: UITextField!
    
    var personData: PersonResponse? // Recibir el objeto PersonResponse
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbluser.adjustFontSize()
        btnAceptar.makeRoundButton(cornerRadius: 5.0)
        viewR.makeRoundView(cornerRadius: 5)
        fetchUserIdentifier()
        
        // Configurar delegados
        txfUsername.delegate = self
        txfEmail.delegate = self
        txfPassword.delegate = self
        txfConfirmarContraseña.delegate = self
        txfCasco.delegate = self
        
        // Inicialmente desactivar el botón
        btnAceptar.isEnabled = false
        
        // Añadir observadores para el contenido de los textfields
        txfUsername.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txfEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txfPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txfConfirmarContraseña.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txfCasco.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Configurar el estado inicial del campo de casco
        updateCascoField()
        
        // Configurar el segmento para detectar cambios
        segRol.addTarget(self, action: #selector(segRolChanged(_:)), for: .valueChanged)
        
        // Cerrar el teclado al tocar fuera de los campos de texto
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Verificar si todos los textfields están llenos
        let allFieldsFilled = txfUsername.text?.isEmpty == false &&
        txfEmail.text?.isEmpty == false &&
        txfPassword.text?.isEmpty == false &&
        txfConfirmarContraseña.text?.isEmpty == false &&
        (segRol.selectedSegmentIndex == 0 || (txfCasco.text?.count ?? 0) == 5)
        btnAceptar.isEnabled = allFieldsFilled
    }
    
    @objc func segRolChanged(_ segmentedControl: UISegmentedControl) {
        updateCascoField()
    }
    
    func updateCascoField() {
        // Deshabilitar y vaciar el campo txfCasco si el rol es "Administrador"
        if segRol.selectedSegmentIndex == 0 { // Suponiendo que 0 es para Administrador
            txfCasco.isEnabled = false
            txfCasco.text = ""
        } else {
            txfCasco.isEnabled = true
        }
    }
    
    @IBAction func cancelarCrearUsuario(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnAceptarTapped(_ sender: UIButton) {
        if let errorMessage = validateFields() {
            showAlert(title: "ERROR", message: errorMessage)
        } else {
            let userDictionary: [String: Any] = [
                "user_name": txfUsername.text ?? "",
                "email": txfEmail.text ?? "",
                "password": txfPassword.text ?? "",
                "rol_id": segRol.selectedSegmentIndex == 0 ? 1 : 2,
                "helmet_id": segRol.selectedSegmentIndex == 0 ? NSNull() : txfCasco.text!,
                "person_id": personData?.id ?? 0
            ]
            
            let helmetSerialNumber = segRol.selectedSegmentIndex == 0 ? nil : txfCasco.text?.isEmpty == false ? txfCasco.text : nil
            var helmetDictionary: [String: String]? = nil
            if let serialNumber = helmetSerialNumber {
                helmetDictionary = [
                    "helmet_serial_number": serialNumber
                ]
            }
            
            if let helmetDict = helmetDictionary {
                ApiService.shared.postHelmetData(helmetDictionary: helmetDict) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let helmetResponse):
                            print("Casco creado con éxito: \(helmetResponse)")
                            
                            var updatedUserDictionary = userDictionary
                            updatedUserDictionary["helmet_id"] = helmetResponse.id
                            
                            ApiService.shared.postUserData(userDictionary: updatedUserDictionary) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(let userResponse):
                                        print("Usuario creado con éxito: \(userResponse)")
                                        
                                        if let registrarDireccionViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegistrarDireccionViewController") as? RegistrarDireccionViewController {
                                            registrarDireccionViewController.user = userResponse
                                            registrarDireccionViewController.helmet = helmetResponse
                                            registrarDireccionViewController.personData = self.personData
                                            self.navigationController?.pushViewController(registrarDireccionViewController, animated: true)
                                        } else {
                                            print("No se pudo instanciar RegistrarDireccionViewController")
                                        }
                                    case .failure(let error):
                                        DispatchQueue.main.async {
                                            self.showAlert(title: "Error al crear el usuario", message: "Username o email ya asignado")
                                        }
                                    }
                                }
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.showAlert(title: "Error al crear el casco", message: "Casco ya registrado")
                            }
                        }
                    }
                }
            } else {
                ApiService.shared.postUserData(userDictionary: userDictionary) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let userResponse):
                            print("Usuario creado con éxito: \(userResponse)")
                            
                            if let registrarDireccionViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegistrarDireccionViewController") as? RegistrarDireccionViewController {
                                registrarDireccionViewController.user = userResponse
                                registrarDireccionViewController.personData = self.personData
                                self.navigationController?.pushViewController(registrarDireccionViewController, animated: true)
                            } else {
                                print("No se pudo instanciar RegistrarDireccionViewController")
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.showAlert(title: "Error al crear el usuario", message: "Username o email ya asignado")
                            }
                        }
                    }
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Navegar al siguiente campo o cerrar el teclado si es el último
        if textField == txfUsername {
            txfEmail.becomeFirstResponder()
        } else if textField == txfEmail {
            txfPassword.becomeFirstResponder()
        } else if textField == txfPassword {
            txfConfirmarContraseña.becomeFirstResponder()
        } else if textField == txfConfirmarContraseña {
            textField.resignFirstResponder() // Cerrar el teclado
        }
        return true
    }
    
    func validateFields() -> String? {
        // Validación del nombre de usuario
        guard let username = txfUsername.text, username.count >= 4 else {
            return "El nombre de usuario debe tener al menos 4 caracteres"
        }
        
        // Validación del email
        guard let email = txfEmail.text, email.contains("@"), email.contains(".") else {
            return "El email debe tener un formato válido"
        }
        
        // Validación de la contraseña
        guard let password = txfPassword.text, password.count >= 8 else {
            return "La contraseña debe tener al menos 8 caracteres"
        }
        
        let hasUpperCase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "\\d", options: .regularExpression) != nil
        let hasSpecialChar = password.range(of: "[!@#$%^&*]", options: .regularExpression) != nil
        
        if !(hasUpperCase && hasNumber && hasSpecialChar) {
            return "La contraseña debe contener al menos una mayúscula, un número y un carácter especial"
        }
        
        // Validación de coincidencia de contraseñas
        guard let confirmPassword = txfConfirmarContraseña.text, confirmPassword == password else {
            return "Las contraseñas no coinciden"
        }
        
        // Validación del casco
        if segRol.selectedSegmentIndex != 1 {
            guard let casco = txfCasco.text, casco.count == 5, !casco.contains(where: { $0.isSymbol || $0.isPunctuation }) else {
                return "El campo del casco debe tener exactamente 5 caracteres alfanuméricos sin caracteres especiales"
            }
        }
        
        return nil
    }

}
