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
        print("ButtonsDireccionViewController - viewDidLoad")
        // En ButtonsDireccionViewController
        if let personData = personData {
            print("personData: \(personData)")
        } else {
            print("No se encontró nada de personData")
        }

        if let userDictionary = userDictionary {
            print("userDictionary: \(userDictionary)")
        } else {
            print("No se encontró nada de userDictionary")
        }

        if let helmetDictionary = helmetDictionary {
            print("helmetDictionary: \(helmetDictionary)")
        } else {
            print("No se encontró nada de helmetDictionary")
        }

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
            print("Navigating to ElegirDireccionViewController")
            // En ButtonsDireccionViewController
            if let personData = personData {
                print("personData: \(personData)")
            } else {
                print("No se encontró nada de personData")
            }

            if let userDictionary = userDictionary {
                print("userDictionary: \(userDictionary)")
            } else {
                print("No se encontró nada de userDictionary")
            }

            if let helmetDictionary = helmetDictionary {
                print("helmetDictionary: \(helmetDictionary)")
            } else {
                print("No se encontró nada de helmetDictionary")
            }

            navigationController?.pushViewController(elegirDireccionViewController, animated: true)
        }
    }

    @IBAction func agregarDirTapped(_ sender: UIButton) {
        // Instanciar la vista desde el storyboard mediante identificador
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let registrarDireccionViewController = storyboard.instantiateViewController(withIdentifier: "RegistrarDireccionViewController") as? RegistrarDireccionViewController {
            // Navegar a la vista
            // En ButtonsDireccionViewController
            if let personData = personData {
                print("personData: \(personData)")
            } else {
                print("No se encontró nada de personData")
            }

            if let userDictionary = userDictionary {
                print("userDictionary: \(userDictionary)")
            } else {
                print("No se encontró nada de userDictionary")
            }

            if let helmetDictionary = helmetDictionary {
                print("helmetDictionary: \(helmetDictionary)")
            } else {
                print("No se encontró nada de helmetDictionary")
            }

            navigationController?.pushViewController(registrarDireccionViewController, animated: true)
        }
    }
}
