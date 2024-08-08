import UIKit

class CodigoViewController: UIViewController {
    @IBOutlet weak var btnCon: UIButton!
    @IBOutlet weak var viewC: UIView!
    @IBOutlet weak var lblCodigo: UILabel!
    @IBOutlet weak var txfPrimerC: UITextField!
    @IBOutlet weak var txfSegundoC: UITextField!
    @IBOutlet weak var txfTercerC: UITextField!
    @IBOutlet weak var txfCuartoC: UITextField!
    @IBOutlet weak var txfQuintoC: UITextField!
    @IBOutlet weak var txfSextoC: UITextField!
    
    var email: String?
    var verificationCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        print("Email recibido: \(email ?? "No email")")
    }

    private func setupView() {
        viewC.makeRoundView(cornerRadius: 5)
        btnCon.makeRoundButton(cornerRadius: 5)
        lblCodigo.adjustFontSize()
        setupTextFields()
    }

    private func setupTextFields() {
        let textFields = [txfPrimerC, txfSegundoC, txfTercerC, txfCuartoC, txfQuintoC, txfSextoC]
        for textField in textFields {
            textField?.delegate = self
            textField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }

    @objc private func textFieldDidChange(textField: UITextField) {
        if textField.text?.count == 1 {
            switch textField {
            case txfPrimerC:
                txfSegundoC.becomeFirstResponder()
            case txfSegundoC:
                txfTercerC.becomeFirstResponder()
            case txfTercerC:
                txfCuartoC.becomeFirstResponder()
            case txfCuartoC:
                txfQuintoC.becomeFirstResponder()
            case txfQuintoC:
                txfSextoC.becomeFirstResponder()
            case txfSextoC:
                txfSextoC.resignFirstResponder()
            default:
                break
            }
        }
    }

    @IBAction func verificarCodigo(_ sender: UIButton) {
        guard let email = email else {
            showAlert(title: "Error", message: "Email no disponible.")
            return
        }

        let textFields = [txfPrimerC, txfSegundoC, txfTercerC, txfCuartoC, txfQuintoC, txfSextoC]
        let verificationCode = textFields.compactMap { $0?.text }.joined()

        guard verificationCode.count == 6 else {
            showAlert(title: "Error", message: "Por favor ingrese todos los dígitos del código.")
            return
        }

        // Debug: Verifica que el código de verificación es correcto
        print("Código de verificación formado: \(verificationCode)")

        ApiService.shared.verifyCode(email: email, verificationCode: verificationCode) { result in
            switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    self.verificationCode = verificationCode
                    self.showAlert(title: "Éxito", message: message) {
                        self.navigateToCambioContra()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    // Debug: Verifica el error recibido
                    print("Error al verificar código: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "No se pudo verificar que el código sea correcto.")
                }
            }
        }
    }

    private func navigateToCambioContra() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let cambioContraVC = storyboard.instantiateViewController(withIdentifier: "CambioContraViewController") as? CambioContraViewController else {
            return
        }
        cambioContraVC.email = email
        cambioContraVC.verificationCode = verificationCode
        // Asegúrate de que el CodigoViewController esté contenido en un UINavigationController
        if let navigationController = navigationController {
            navigationController.pushViewController(cambioContraVC, animated: true)
        } else {
            // Si no está en un UINavigationController, presenta el view controller de manera modal
            present(cambioContraVC, animated: true, completion: nil)
        }
    }
}

extension CodigoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString: NSString = textField.text as NSString? ?? ""
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
