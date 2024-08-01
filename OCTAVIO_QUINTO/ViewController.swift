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
    }
    
    override func viewDidLayoutSubviews() {
        viewLogo.makeRoundView()
        btnIngresar.makeRoundButton(cornerRadius: 5.0)
    }
    
    @objc func loginTapped() {
        // Desactiva el botón para evitar múltiples clics
        btnIngresar.isEnabled = false
        
        guard let user = txfIdentificador.text, !user.isEmpty,
              let password = txfContraseña.text, !password.isEmpty else {
            print("Usuario o contraseña vacíos")
            // Reactiva el botón si los campos están vacíos
            btnIngresar.isEnabled = true
            return
        }

        ApiService.shared.login(user: user, password: password) { result in
            // Reactiva el botón en cualquier caso
            DispatchQueue.main.async {
                self.btnIngresar.isEnabled = true
            }
            
            switch result {
            case .success(let token):
                UserDefaults.standard.set(token, forKey: "authToken")
                print("Token recibido: \(token)")
                
                DispatchQueue.main.async {
                    if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                        sceneDelegate.userDidLogin()
                    }
                }
                
            case .failure(let error):
                print("Error en la solicitud: \(error.localizedDescription)")
            }
        }
    }
}
