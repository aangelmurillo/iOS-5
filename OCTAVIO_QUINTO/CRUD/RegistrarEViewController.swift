import UIKit

class RegistrarEViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var viewR: UIView!
    @IBOutlet weak var btnAcep: UIButton!
    @IBOutlet weak var lblRegistrar: UILabel!
    @IBOutlet weak var txfNombre: UITextField!
    @IBOutlet weak var txfAPaterno: UITextField!
    @IBOutlet weak var txfAMaterno: UITextField!
    @IBOutlet weak var txfCURP: UITextField!
    @IBOutlet weak var txfTelefono: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        lblRegistrar.adjustFontSize()
        btnAcep.makeRoundButton(cornerRadius: 5)
        viewR.makeRoundView(cornerRadius: 5)
        fetchUserIdentifier()
        
        // Configurar los delegados de los textfields
        txfNombre.delegate = self
        txfAPaterno.delegate = self
        txfAMaterno.delegate = self
        txfCURP.delegate = self
        txfTelefono.delegate = self
        
        // Inicialmente desactivar el botón
        btnAcep.isEnabled = false
        
        // Añadir observadores para el contenido de los textfields
        txfNombre.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txfAPaterno.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txfAMaterno.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txfCURP.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txfTelefono.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Cerrar el teclado al tocar fuera de los campos de texto
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        // Verificar si todos los textfields están llenos y válidos
        let isNombreValid = !(txfNombre.text?.isEmpty ?? true)
        let isAPaternoValid = !(txfAPaterno.text?.isEmpty ?? true)
        let isAMaternoValid = !(txfAMaterno.text?.isEmpty ?? true)
        let isCURPValid = !(txfCURP.text?.isEmpty ?? true) && txfCURP.text?.count == 18
        let isTelefonoValid = !(txfTelefono.text?.isEmpty ?? true) && txfTelefono.text?.count == 10

        // Activar el botón solo si todos los campos son válidos
        btnAcep.isEnabled = isNombreValid && isAPaternoValid && isAMaternoValid && isCURPValid && isTelefonoValid
    }

    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        // Validar los datos antes de navegar
        guard let nombre = txfNombre.text, !nombre.isEmpty,
              let apaterno = txfAPaterno.text, !apaterno.isEmpty,
              let amaterno = txfAMaterno.text, !amaterno.isEmpty,
              let curp = txfCURP.text, curp.count == 18,
              let telefono = txfTelefono.text, telefono.count == 10 else {
            // Mostrar un mensaje de error si los datos no son válidos
            showAlert(title:"ERROR", message: "Por favor, completa todos los campos correctamente.")
            return
        }

        // Crear el diccionario con los datos de los campos de texto
        let personData: [String: Any] = [
            "person_name": nombre,
            "person_last_name": apaterno,
            "person_second_last_name": amaterno,
            "person_curp": curp,
            "person_phone_number": telefono,
        ]
        
        // Crear una instancia de `RegistrarUserViewController`
        if let crearUsuarioVC = storyboard?.instantiateViewController(withIdentifier: "RegistrarUserViewController") as? RegistrarUserViewController {
            // Pasar el diccionario a la nueva vista
            crearUsuarioVC.personData = personData
            
            // Navegar a la nueva vista
            navigationController?.pushViewController(crearUsuarioVC, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Cerrar el teclado
        return true
    }

}
