import UIKit

class CambioContraViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnEn: UIButton!
    @IBOutlet weak var viewCon: UIView!
    @IBOutlet weak var lblCambioC: UILabel!
    @IBOutlet weak var txfNuevaContraseña: UITextField!
    @IBOutlet weak var txfConfContraseña: UITextField!
    
    var email: String?
    var verificationCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        btnEn.makeRoundButton(cornerRadius: 5)
        viewCon.makeRoundView(cornerRadius: 5)
        lblCambioC.adjustFontSize()
        
        // Configura el UITextField
        txfNuevaContraseña.delegate = self
        txfConfContraseña.delegate = self

        print("Email recibido en cambiar contra: \(email ?? "No se recibió nada")")
        print("VerificationCode recibido en cambiar contra: \(verificationCode ?? "No se recibió nada")")
    }

    
    @IBAction func confirmarNuevaContraseña(_ sender: UIButton) {
        guard let email = email else {
            showAlert(title: "Error", message: "Email no disponible.")
            return
        }

        guard let nuevaContraseña = txfNuevaContraseña.text, !nuevaContraseña.isEmpty,
              let confContraseña = txfConfContraseña.text, !confContraseña.isEmpty else {
            showAlert(title: "Error", message: "Por favor, ingresa todas las contraseñas.")
            return
        }

        if nuevaContraseña != confContraseña {
            showAlert(title: "Error", message: "Las contraseñas no coinciden.")
            return
        }

        // Validar la nueva contraseña
        if !isValidPassword(nuevaContraseña) {
            showAlert(title: "Error", message: "La contraseña debe tener al menos 8 caracteres, una mayúscula, un número y un carácter especial.")
            return
        }

        guard let verificationCode = verificationCode else {
            showAlert(title: "Error", message: "Código de verificación no disponible.")
            return
        }

        ApiService.shared.updatePassword(email: email, newPassword: nuevaContraseña, verificationCode: verificationCode) { result in
            switch result {
            case .success(let responseMessage):
                DispatchQueue.main.async {
                    self.showAlert(title: "Éxito", message: responseMessage) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }

    func isValidPassword(_ password: String) -> Bool {
        // Expresión regular para validar la contraseña
        let passwordPattern = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
        return passwordPredicate.evaluate(with: password)
    }

}
