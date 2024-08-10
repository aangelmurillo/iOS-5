import UIKit

class IngresarcViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var btnEnvi: UIButton!
    @IBOutlet weak var viewEm: UIView!
    @IBOutlet weak var lblBreve: UILabel!
    @IBOutlet weak var lblIngresar: UILabel!
    
    var seguePerformed = false  // Variable para controlar la ejecución del segue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblBreve.adjustFontSize()
        lblIngresar.adjustFontSize()
        btnEnvi.makeRoundButton(cornerRadius: 5)
        viewEm.makeRoundView(cornerRadius: 5)
        
        txfEmail.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Resetear la variable seguePerformed cuando la vista aparece
        seguePerformed = false
    }
    
    @IBAction func enviarCodigo(_ sender: UIButton) {
        print("Botón Enviar presionado")
        
        guard let email = txfEmail.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Por favor ingresa un correo electrónico válido.")
            return
        }
        
        btnEnvi.isEnabled = false
        
        ApiService.shared.sendPasswordCode(email: email) { [weak self] result in
            DispatchQueue.main.async {
                print("Resultado recibido")
                switch result {
                case .success(let responseMessage):
                    print("Código de verificación enviado: \(responseMessage)")
                    if !(self?.seguePerformed ?? false) {
                        // Crear instancia de CodigoViewController y realizar el push
                        if let navigationController = self?.navigationController {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let codigoVC = storyboard.instantiateViewController(withIdentifier: "CodigoViewController") as? CodigoViewController {
                                codigoVC.email = self?.txfEmail.text
                                navigationController.pushViewController(codigoVC, animated: true)
                                self?.seguePerformed = true
                            }
                        }
                    }
                case .failure(let error):
                    print("Error al enviar el código de verificación: \(error.localizedDescription)")
                    if let data = error as? CustomError, let response = data.response {
                        print("Respuesta del servidor: \(response)")
                    }
                    self?.showAlert(title: "Error", message: "Hubo un problema al enviar el código de verificación. Inténtalo de nuevo.")
                }
                
                self?.btnEnvi.isEnabled = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfEmail {
            enviarCodigo(btnEnvi)
        }
        return true
    }
}
