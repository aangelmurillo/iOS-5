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
    
    var personData: [String: Any]?
    var userDictionary: [String: Any]?
    var helmetDictionary: [String: Any]?
    
    // Define addressData como una propiedad de la clase
    var addressData: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserIdentifier()
        
        // Asignar delegados
        [txfCalle, txfNumExterior, txfNumInt, txfCP, txfColonia, txfCiudad, txfEstado, txfPais].forEach {
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        btnCrearUsuario.alpha = 0.5
        
        // Cerrar el teclado al tocar fuera de los campos de texto
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
        // Verificar que todos los campos necesarios estén llenos, excepto txfNumInt
        let fields = [txfCalle, txfNumExterior, txfCP, txfColonia, txfCiudad, txfEstado, txfPais]
        let allFieldsFilled = fields.allSatisfy { $0?.text?.isEmpty == false }
        
        // Habilitar el botón si todos los campos necesarios están llenos
        btnCrearUsuario.isEnabled = allFieldsFilled
        btnCrearUsuario.alpha = allFieldsFilled ? 1.0 : 0.5
    }
    
    @IBAction func crearNuevUsuario(_ sender: UIButton) {
        // Verificar si `personData` está presente
        guard let personData = personData else {
            print("Datos de la persona no encontrados")
            return
        }
        
        // Crear la persona y obtener el ID
        ApiService.shared.postPersonData(personData: personData) { result in
            switch result {
            case .success(let personResponse):
                // Extraer el ID de la respuesta
                let personId = personResponse.id
                
                // Actualizar addressData con el ID de la persona
                self.addressData = [
                    "address_street": self.txfCalle.text ?? "",
                    "address_exterior_number": self.txfNumExterior.text ?? "",
                    "address_interior_number": self.txfNumInt.text?.isEmpty ?? true ? NSNull() : self.txfNumInt.text!,
                    "address_neighborhood": self.txfColonia.text ?? "",
                    "address_zip_code": self.txfCP.text ?? "",
                    "address_city": self.txfCiudad.text ?? "",
                    "address_state": self.txfEstado.text ?? "",
                    "address_country": self.txfPais.text ?? "",
                    "address_references": "", // Puedes agregar una referencia si es necesario
                    "person_id": personId // Usar el ID de la persona creada
                ]
                
                // Imprimir el diccionario para verificar el contenido
                print("Datos de la dirección actualizados:", self.addressData ?? [:])
                
                // Llamar al método postAddressData para enviar la dirección
                if let addressData = self.addressData {
                    ApiService.shared.postAddressData(addressData: addressData) { result in
                        switch result {
                        case .success(let addressResponse):
                            print("Dirección creada con éxito: \(addressResponse)")
                        case .failure(let error):
                            print("No se pudo crear la dirección: \(error.localizedDescription)")
                        }
                    }
                }
                
            case .failure(let error):
                print("No se pudo crear el usuario: \(error.localizedDescription)")
            }
        }
    }

    @IBAction func cancelarCrearUsuario(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
