import UIKit

class ScrollViewUserSensorsViewController: UIViewController {
    @IBOutlet weak var scrUsersSensors: UIScrollView!
    
    private let viewContent = UIView()
    private var users: [User] = [] // Agregamos una propiedad para almacenar la lista de usuarios
    
    enum ActionType {
        case edit
        case delete
    }
    
    var userName: String?
    var userEmail: String?
    var actionType: ActionType?
    var tabIdentifier: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserIdentifier()
        fetchAllUsers() // Llama a fetchAllUsers cada vez que la vista aparece
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
    
    func addUserViews(users: [User]) {
        self.users = users // Guardamos la lista de usuarios
        
        // Limpia las vistas previas antes de agregar nuevas
        viewContent.subviews.forEach { $0.removeFromSuperview() }
        
        for (i, user) in users.enumerated() {
            let userView = UIView()
            userView.makeRoundView(cornerRadius: 10.0)
            userView.backgroundColor = (tabIdentifier == 2) ? .systemYellow : .systemMint
            userView.translatesAutoresizingMaskIntoConstraints = false
            viewContent.addSubview(userView)
            
            let imageView = UIImageView()
            imageView.image = UIImage(named: "user.png")
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            userView.addSubview(imageView)
            
            let label = UILabel()
            label.text = user.user_name
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
            
            if i == users.count - 1 {
                userView.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: -20).isActive = true
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let selectedUser = users[sender.tag] // Obtén el usuario seleccionado
        print("Usuario seleccionado: \(selectedUser.user_name), ID: \(selectedUser.id), Email: \(selectedUser.email), Helmet Serial Number: \(selectedUser.helmet!.helmet_serial_number)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let actionType = actionType {
            switch actionType {
            case .edit:
                if let editarViewController = storyboard.instantiateViewController(withIdentifier: "EditarViewController") as? EditarViewController {
                    navigationController?.pushViewController(editarViewController, animated: true)
                }
            case .delete:
                let alertController = UIAlertController(title: "Confirmar eliminación", message: "¿Estás seguro de que deseas eliminar al usuario \(selectedUser.user_name)?", preferredStyle: .alert)
                
                let confirmAction = UIAlertAction(title: "Confirmar", style: .destructive) { _ in
                    print("Usuario \(selectedUser.user_name) eliminado")
                }
                let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
            }
        } else {
            // Acción predeterminada si no es eliminar o editar
            if let tabIdentifier = tabIdentifier {
                switch tabIdentifier {
                case 0:
                    if let sensorsViewController = storyboard.instantiateViewController(withIdentifier: "SensorsViewController") as? SensorsViewController {
                        sensorsViewController.selectedUser = selectedUser
                        navigationController?.pushViewController(sensorsViewController, animated: true)
                    }
                case 2:
                    if let informacionViewController = storyboard.instantiateViewController(withIdentifier: "InformacionViewController") as? InformacionViewController {
                        navigationController?.pushViewController(informacionViewController, animated: true)
                    }
                default:
                    // Manejar otros casos si es necesario
                    break
                }
            }
        }
    }
    
    func fetchAllUsers() {
        ApiService.shared.fetchAllUsers { result in
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    self.addUserViews(users: users)
                }
            case .failure(let error):
                print("Error al obtener la lista de usuarios (FetchAllUsers): \(error.localizedDescription)")
            }
        }
    }
}
