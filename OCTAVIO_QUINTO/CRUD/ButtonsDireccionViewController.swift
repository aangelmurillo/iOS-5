import UIKit

class ButtonsDireccionViewController: UIViewController {
    @IBOutlet var viewsBtnsDir: [UIView]!
    @IBOutlet weak var lblSeleccionarDir: UILabel!
    @IBOutlet weak var lblAgregarDir: UILabel!
    
    var personData: [String: Any]?
    var userDictionary: [String: Any]?
    var helmetDictionary: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserIdentifier()
        // Do any additional setup after loading the view.
        print(personData ?? "No se encontró nada de personData")
        print(userDictionary ?? "No se encontró nada de userDictionary")
        print(helmetDictionary ?? "No se encontró nada de helmetDictionary")
    }
    
    @IBAction func seleccionarDirTapped(_ sender: UIButton) {
        // Instanciar la vista desde el storyboard mediante identificador
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let elegirDireccionViewController = storyboard.instantiateViewController(withIdentifier: "ElegirDireccionViewController") as? ElegirDireccionViewController {
            // Pasar los datos necesarios
            elegirDireccionViewController.personData = personData
            elegirDireccionViewController.userDictionary = userDictionary
            elegirDireccionViewController.helmetDictionary = helmetDictionary
            // Navegar a la vista
            navigationController?.pushViewController(elegirDireccionViewController, animated: true)
        }
    }

    @IBAction func agregarDirTapped(_ sender: UIButton) {
        // Instanciar la vista desde el storyboard mediante identificador
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let registrarDireccionViewController = storyboard.instantiateViewController(withIdentifier: "RegistrarDireccionViewController") as? RegistrarDireccionViewController {
            // Pasar los datos necesarios
            registrarDireccionViewController.personData = personData
            registrarDireccionViewController.userDictionary = userDictionary
            registrarDireccionViewController.helmetDictionary = helmetDictionary
            // Navegar a la vista
            navigationController?.pushViewController(registrarDireccionViewController, animated: true)
        }
    }
}
