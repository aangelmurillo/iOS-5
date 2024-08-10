import UIKit

class InformacionViewController: UIViewController {
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet var lblsInfo: [UILabel]!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblAPaterno: UILabel!
    @IBOutlet weak var lblAMaterno: UILabel!
    @IBOutlet weak var lblCURP: UILabel!
    @IBOutlet weak var lblTel: UILabel!
    @IBOutlet weak var lblRol: UILabel!
    
    var selectedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInfo.makeRoundView(cornerRadius: 5)
        
        // Ajustar el tamaño de fuente para todas las etiquetas
        adjustFontSizeForAllLabels()
        
        // Configurar la vista con la información del usuario
        configureUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = selectedUser {
            let serialNumber = user.helmet?.helmet_serial_number ?? "nil"
            configureCenteredNavBar(title: user.user_name, subtitle: serialNumber)
        }
    }
    
    private func adjustFontSizeForAllLabels() {
        // Ajustar el tamaño de fuente para lblsInfo
        for label in lblsInfo {
            label.adjustFontSize()
        }
        
        // Ajustar el tamaño de fuente para las etiquetas individuales
        lblNombre.adjustFontSize()
        lblAPaterno.adjustFontSize()
        lblAMaterno.adjustFontSize()
        lblCURP.adjustFontSize()
        lblTel.adjustFontSize()
        lblRol.adjustFontSize()
    }
    
    private func configureUserInfo() {
        guard let user = selectedUser else { return }
        
        lblNombre.text = user.person.person_name
        lblAPaterno.text = user.person.person_last_name
        lblAMaterno.text = user.person.person_second_last_name
        lblCURP.text = user.person.person_curp
        lblTel.text = user.person.person_phone_number
        
        // Configurar lblRol basado en rol_id
        switch user.rol_id {
        case 1:
            lblRol.text = "Admin"
        case 2:
            lblRol.text = "Empleado"
        default:
            lblRol.text = "Rol desconocido"
        }
    }
}
