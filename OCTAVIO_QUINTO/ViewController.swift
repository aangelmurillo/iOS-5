import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
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
        
        txfIdentificador.delegate = self
        txfContraseña.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
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
                
                // Fetch user info after successful login
                self.fetchUserInfoAndRedirect()
                
            case .failure(let error):
                // Mostrar el mensaje de error en una alerta
                DispatchQueue.main.async {
                    self.showAlert(title: "Error de autenticación", message: "Usuario o contraseña incorrectos")
                }
                print("Error en la solicitud: \(error.localizedDescription)")
            }
        }
    }

    // Fetch user info and redirect based on role
    func fetchUserInfoAndRedirect() {
        ApiService.shared.fetchUserInfo { result in
            switch result {
            case .success(let user):
                print("Nombre de usuario: \(user.user_name)")
                print("Correo electrónico: \(user.email)")
                print("Rol del usuario: \(user.rol_id)")
                
                DispatchQueue.main.async {
                    if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                        sceneDelegate.userDidLogin(role_id: user.rol_id)
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error al obtener la información del usuario", message: "Login fallido")
                }
                print("Error al obtener la información del usuario: \(error.localizedDescription)")
            }
        }
    }
    
    // UITextFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfIdentificador {
            txfContraseña.becomeFirstResponder()
        } else if textField == txfContraseña {
            loginTapped()
        }
        return true
    }
}
