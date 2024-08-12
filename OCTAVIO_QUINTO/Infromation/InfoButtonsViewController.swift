import UIKit

class InfoButtonsViewController: UIViewController {
    @IBOutlet weak var btnHistorialSensores: UIButton!
    @IBOutlet weak var btnInfoEmpleado: UIButton!
    
    var selectedUser: User?
    var userRole: Int? // Variable para almacenar el valor del rol del usuario
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserInfo()
    }
    
    @IBAction func btnInfoEmpleadoTapped(_ sender: UIButton) {
        // Crear una instancia de InformacionViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let informacionVC = storyboard.instantiateViewController(withIdentifier: "InformacionViewController") as? InformacionViewController {
            // Configurar el objeto selectedUser en la vista de destino
            informacionVC.selectedUser = selectedUser
            
            // Presentar el InformacionViewController
            navigationController?.pushViewController(informacionVC, animated: true)
        }
    }
    
    @IBAction func btnHistorialSensoresTapped(_ sender: UIButton) {
        // Crear una instancia de HistorialButtonsViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let historialVC = storyboard.instantiateViewController(withIdentifier: "PersonalHelmetViewController") as? PersonalHelmetViewController {
            // Configurar el objeto selectedUser en la vista de destino
            historialVC.selectedUser = selectedUser
            
            // Presentar el HistorialButtonsViewController
            navigationController?.pushViewController(historialVC, animated: true)
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
