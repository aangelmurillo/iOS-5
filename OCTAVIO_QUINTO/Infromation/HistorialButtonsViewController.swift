import UIKit

class HistorialButtonsViewController: UIViewController {

    var selectedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = selectedUser {
            let serialNumber = user.helmet?.helmet_serial_number ?? "nil"
            configureCenteredNavBar(title: user.user_name, subtitle: serialNumber)
        }
    }

    @IBAction func showPersonalInfo(_ sender: UIButton) {
        // Crear una instancia del storyboard y del controlador de destino
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let informacionVC = storyboard.instantiateViewController(withIdentifier: "PersonalHelmetViewController") as? PersonalHelmetViewController {
            // Configurar el objeto selectedUser en la vista de destino
            informacionVC.selectedUser = selectedUser
            
            // Presentar el InformacionViewController modalmente
            informacionVC.modalPresentationStyle = .automatic // o .automatic según lo que necesites
            present(informacionVC, animated: true, completion: nil)
        }
    }
    /*
    @IBAction func showGeneralInfo(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let informacionVC = storyboard.instantiateViewController(withIdentifier: "GeneralHelmetViewController") as? GeneralHelmetViewController {
            // Configurar el objeto selectedUser en la vista de destino
            informacionVC.selectedUser = selectedUser
            
            // Presentar el InformacionViewController modalmente
            informacionVC.modalPresentationStyle = .automatic // o .automatic según lo que necesites
            present(informacionVC, animated: true, completion: nil)
        }
    }*/
}
