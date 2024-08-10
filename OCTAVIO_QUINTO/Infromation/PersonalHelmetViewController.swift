import UIKit

class PersonalHelmetViewController: UIViewController {
    @IBOutlet weak var dpkFecha: UIDatePicker!
    @IBOutlet weak var lblPresion: UILabel!
    @IBOutlet weak var lblTemperatura: UILabel!
    @IBOutlet weak var lblHumedad: UILabel!
    @IBOutlet weak var lblAltitud: UILabel!
    
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
}
