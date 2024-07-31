import UIKit

class ScrollViewUserSensorsViewController: UIViewController {
    @IBOutlet weak var scrUsersSensors: UIScrollView!
    
    private let viewContent = UIView()
    
    enum ActionType {
        case edit
        case delete
    }
    
    var actionType: ActionType?
    var tabIdentifier: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewContent()
        addUserViews()
        
        // Recuperar el userId de UserDefaults
        if let userId = UserDefaults.standard.value(forKey: "userId") as? Int {
            ApiService.shared.getUserInfo(userId: userId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let usuario):
                        self?.configureCustomNavigationBar(title: usuario.userName, subtitle: usuario.email)
                        // Guardar usuario en UserDefaults
                        if let userData = try? JSONEncoder().encode(usuario) {
                            UserDefaults.standard.set(userData, forKey: "loggedUser")
                        }
                    case .failure(let error):
                        print("Error al obtener la información del usuario: \(error)")
                        self?.configureCustomNavigationBar(title: "Usuario", subtitle: "email@dominio.com")
                    }
                }
            }
        } else {
            print("Error: No se encontró el userId en UserDefaults")
        }
    }
    
    func setUpViewContent() {
        scrUsersSensors.addSubview(viewContent)
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewContent.leadingAnchor.constraint(equalTo: scrUsersSensors.leadingAnchor),
            viewContent.trailingAnchor.constraint(equalTo: scrUsersSensors.trailingAnchor),
            viewContent.topAnchor.constraint(equalTo: scrUsersSensors.topAnchor),
            viewContent.bottomAnchor.constraint(equalTo: scrUsersSensors.bottomAnchor),
            viewContent.widthAnchor.constraint(equalTo: scrUsersSensors.widthAnchor)
        ])
    }
    
    func addUserViews() {
        let numberOfUsers = 9
        
        for i in 0..<numberOfUsers {
            let userView = UIView()
            userView.makeRoundView(cornerRadius: 10.0)
            if tabIdentifier == 2 {
                userView.backgroundColor = .systemYellow
            } else {
                userView.backgroundColor = .systemMint
            }
            userView.translatesAutoresizingMaskIntoConstraints = false
            viewContent.addSubview(userView)
            
            let imageView = UIImageView()
            imageView.image = UIImage(named: "user.png")
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            userView.addSubview(imageView)
            
            let label = UILabel()
            label.text = "User \(i + 1)"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            userView.addSubview(label)
            
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = i
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            userView.addSubview(button)
            
            let row = i / 2
            let column = i % 2
            
            NSLayoutConstraint.activate([
                userView.widthAnchor.constraint(equalTo: scrUsersSensors.widthAnchor, multiplier: 0.4),
                userView.heightAnchor.constraint(equalTo: userView.widthAnchor, multiplier: 1.0),
                column == 0 ?
                    userView.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: 20) :
                    userView.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: -20),
                userView.topAnchor.constraint(equalTo: row == 0 ? viewContent.topAnchor : viewContent.subviews[(row * 2) - 1].bottomAnchor, constant: 20),
                
                imageView.centerXAnchor.constraint(equalTo: userView.centerXAnchor),
                imageView.topAnchor.constraint(equalTo: userView.topAnchor, constant: 20.0),
                imageView.widthAnchor.constraint(equalTo: userView.widthAnchor, multiplier: 0.5),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
                
                label.leadingAnchor.constraint(equalTo: userView.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: userView.trailingAnchor),
                label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10.0),
                
                button.topAnchor.constraint(equalTo: userView.topAnchor),
                button.bottomAnchor.constraint(equalTo: userView.bottomAnchor),
                button.leadingAnchor.constraint(equalTo: userView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: userView.trailingAnchor)
            ])
            
            if i == numberOfUsers - 1 {
                userView.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: -20).isActive = true
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let actionType = actionType {
            switch actionType {
            case .edit:
                if let editarViewController = storyboard.instantiateViewController(withIdentifier: "EditarViewController") as? EditarViewController {
                    navigationController?.pushViewController(editarViewController, animated: true)
                }
            case .delete:
                let alertController = UIAlertController(title: "Confirmar eliminación", message: "¿Estás seguro de que deseas eliminar al usuario \(sender.tag + 1)?", preferredStyle: .alert)
                
                let confirmAction = UIAlertAction(title: "Confirmar", style: .destructive) { _ in
                    print("Usuario \(sender.tag + 1) eliminado")
                }
                let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
            }
        } else {
            // Acción predeterminada si no es eliminar o editar
            if let navigationController = self.navigationController {
                if let tabIdentifier = tabIdentifier {
                    switch tabIdentifier {
                    case 0:
                        if let sensorsViewController = storyboard.instantiateViewController(withIdentifier: "SensorsViewController") as? SensorsViewController {
                            navigationController.pushViewController(sensorsViewController, animated: true)
                        }
                    case 2:
                        if let informacionViewController = storyboard.instantiateViewController(withIdentifier: "InformacionViewController") as? InformacionViewController {
                            navigationController.pushViewController(informacionViewController, animated: true)
                        }
                    default:
                        // Manejar otros casos si es necesario
                        break
                    }
                }
            }
        }
    }

}
