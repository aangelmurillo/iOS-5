import UIKit

class SensorsViewController: UIViewController {
    @IBOutlet var btnsSensors: [UIButton]!
    @IBOutlet var viewsSensors: [UIView]!
    
    var selectedUser: User?
    var userRole: Int? // Variable para almacenar el valor del rol del usuario
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Asignar el método handleButtonTap a cada botón
        for button in btnsSensors {
            button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for view in viewsSensors {
            view.makeRoundView(cornerRadius: 10.0)
        }
        print(selectedUser ?? "No se seleccionó")
        fetchUserInfo()
    }
    
    @objc func handleButtonTap(_ sender: UIButton) {
        guard let user = selectedUser else {
            print("No user selected")
            return
        }
        
        var viewControllerIdentifier: String
        
        switch sender.tag {
        case 0:
            viewControllerIdentifier = "GPSViewController"
        case 1:
            viewControllerIdentifier = "EnvironmentViewController"  // Corregido: Tag 1 es Environment
        case 2:
            viewControllerIdentifier = "TemperatureViewController"  // Corregido: Tag 2 es Temperature
        case 3:
            viewControllerIdentifier = "CameraViewController"
        default:
            print("Invalid tag")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? UIViewController & UserReceivable {
            viewController.selectedUser = user
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("View controller with identifier \(viewControllerIdentifier) not found or does not conform to UserReceivable protocol")
        }
    }
    
    func fetchUserInfo() {
        ApiService.shared.fetchUserInfo { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.userRole = user.rol_id
                    
                    // Configurar la barra de navegación basada en el role_id
                    if user.rol_id == 2 {
                        self?.selectedUser = user
                        self?.configureCenteredNavBar(title: user.user_name, subtitle: user.helmet?.helmet_serial_number ?? "Casco no encontrado")
                    } else {
                        self?.configureCenteredNavBar(title: self?.selectedUser?.user_name ?? "Nombre no encontrado", subtitle: self?.selectedUser?.email ?? "Email no encontrado")
                    }
                    
                }
            case .failure(let error):
                print("Error al obtener la información del usuario: \(error.localizedDescription)")
            }
        }
    }
}

// Protocolo para asegurar que los view controllers pueden recibir un objeto User
protocol UserReceivable: AnyObject {
    var selectedUser: User? { get set }
}

// Conformar los view controllers al protocolo UserReceivable
extension GPSViewController: UserReceivable {}
extension TemperatureViewController: UserReceivable {}
extension EnvironmentViewController: UserReceivable {}
extension CameraViewController: UserReceivable {}
