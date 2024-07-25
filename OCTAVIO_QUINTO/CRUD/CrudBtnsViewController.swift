import UIKit

class CrudBtnsViewController: UIViewController {

    @IBOutlet weak var BtnEli: UIButton!
    @IBOutlet weak var BtnEdit: UIButton!
    @IBOutlet weak var btnRE: UIButton!
    
    // Variable para rastrear si el segue ya se ha realizado
    private var isSegueAlreadyPerformed = true

    override func viewDidLoad() {
        super.viewDidLoad()
        btnRE.makeRoundButton(cornerRadius: 5)
        BtnEli.makeRoundButton(cornerRadius: 5)
        BtnEdit.makeRoundButton(cornerRadius: 5)
        
        configureCustomNavigationBar(title: "Ing. Octavio", subtitle: "octavio@gmail.com")
        
        BtnEli.addTarget(self, action: #selector(eliminarBtnTapped), for: .touchUpInside)
        BtnEdit.addTarget(self, action: #selector(editarBtnTapped), for: .touchUpInside)
    }
    
    @objc func eliminarBtnTapped() {
        if !isSegueAlreadyPerformed {
            performSegue(withIdentifier: "showDeleteSensors", sender: self)
        }
    }
    
    @objc func editarBtnTapped() {
        if !isSegueAlreadyPerformed {
            performSegue(withIdentifier: "showEditSensors", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ScrollViewUserSensorsViewController {
            if segue.identifier == "showDeleteSensors" {
                destinationVC.actionType = .delete
            } else if segue.identifier == "showEditSensors" {
                destinationVC.actionType = .edit
            }
        }
    }
    
    // Puedes restablecer la variable cuando sea necesario
    func resetSegueFlag() {
        isSegueAlreadyPerformed = false
    }
}
