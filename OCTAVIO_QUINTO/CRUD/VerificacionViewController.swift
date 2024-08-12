import UIKit

class VerificacionViewController: UIViewController {
    
    @IBOutlet weak var btnCon: UIButton!
    @IBOutlet weak var lblCodigo: UILabel!
    @IBOutlet weak var txfPrimerC: UITextField!
    @IBOutlet weak var txfSegundoC: UITextField!
    @IBOutlet weak var txfTercerC: UITextField!
    @IBOutlet weak var txfCuartoC: UITextField!
    @IBOutlet weak var txfQuintoC: UITextField!
    @IBOutlet weak var txfSextoC: UITextField!
    
    var userResponse: UserResponse?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configura la vista y los textfields
        setupView()
        print(userResponse ?? "No llegó ningún userResponse")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func setupView() {
        // Configuración de las vistas
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
        guard let userResponse = userResponse else {
            showAlert(title: "Error", message: "No se recibieron datos del usuario.")
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

        // Aquí se realiza la verificación del código
        ApiService.shared.verifyAccount(email: userResponse.email, code: verificationCode) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    // Aquí hacemos el pop to root view controller
                    if let navigationController = self.navigationController {
                        navigationController.popToRootViewController(animated: true)
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

}

extension VerificacionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString: NSString = textField.text as NSString? ?? ""
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        // Define the text field type
        if [txfPrimerC, txfSegundoC, txfTercerC].contains(textField) {
            // Text fields 1 to 3 accept only letters
            let allowedCharacters = CharacterSet.letters
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet) && newString.length <= maxLength
        } else if [txfCuartoC, txfQuintoC, txfSextoC].contains(textField) {
            // Text fields 4 to 6 accept only digits
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet) && newString.length <= maxLength
        }
        
        return newString.length <= maxLength
    }
}
