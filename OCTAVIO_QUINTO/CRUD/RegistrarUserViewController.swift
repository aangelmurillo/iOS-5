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

    var personData: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        lbluser.adjustFontSize()
        btnAceptar.makeRoundButton(cornerRadius: 5.0)
        viewR.makeRoundView(cornerRadius: 5)
        fetchUserIdentifier()
        print(personData ?? "No se encontró nada de personData")

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
                              txfConfirmarContraseña.text?.isEmpty == false
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
            showAlert(title:"ERROR" ,message: errorMessage)
        } else {
            // Crear el diccionario con los campos de la estructura User
            let userDictionary: [String: Any] = [
                "user_name": txfUsername.text ?? "",
                "email": txfEmail.text ?? "",
                "password": txfPassword.text ?? "",
                "rol_id": segRol.selectedSegmentIndex == 0 ? 1 : 2,
                "helmet_id": segRol.selectedSegmentIndex == 0 ? NSNull() : txfCasco.text!
            ]
            
            // Verificar si helmet_serial_number es válido
            let helmetSerialNumber = segRol.selectedSegmentIndex == 0 ? nil : txfCasco.text?.isEmpty == false ? txfCasco.text : nil
            
            var helmetDictionary: [String: String]? = nil
            if let serialNumber = helmetSerialNumber {
                helmetDictionary = [
                    "helmet_serial_number": serialNumber
                ]
            }
            
            // Aquí puedes usar `userDictionary` y `helmetDictionary` para lo que necesites, por ejemplo, enviar a un servidor
            print(userDictionary)
            if let helmetDict = helmetDictionary {
                print(helmetDict)
            }
            
            // Navegar a la siguiente vista si es necesario
            if let buttonsDireccionViewController = storyboard?.instantiateViewController(withIdentifier: "ButtonsDireccionViewController") as? ButtonsDireccionViewController {
                buttonsDireccionViewController.userDictionary = userDictionary
                buttonsDireccionViewController.helmetDictionary = helmetDictionary
                navigationController?.pushViewController(buttonsDireccionViewController, animated: true)
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
        
        return nil
    }
}
