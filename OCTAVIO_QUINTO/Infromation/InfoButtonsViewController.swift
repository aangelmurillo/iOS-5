import UIKit

class InfoButtonsViewController: UIViewController {
    @IBOutlet weak var btnHistorialSensores: UIButton!
    @IBOutlet weak var btnInfoEmpleado: UIButton!
    
    var selectedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = selectedUser {
            let serialNumber = user.helmet?.helmet_serial_number ?? "nil"
            configureCenteredNavBar(title: user.user_name, subtitle: serialNumber)
        }
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
}
