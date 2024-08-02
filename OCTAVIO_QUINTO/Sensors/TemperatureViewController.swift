import UIKit

class TemperatureViewController: UIViewController {
    
    var selectedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = selectedUser {
            print("User Name: \(user.user_name)")
            print("User Email: \(user.email)")
            print("Helmet Serial Number: \(user.helmet.helmet_serial_number)")
            
            // Llamar a fetchSensorData desde ApiService
            ApiService.shared.fetchSensorData(helmetId: user.helmet.helmet_serial_number, sensorType: "temperatura") { result in
                switch result {
                case .success(let sensorData):
                    print("Sensor Data: \(sensorData)")
                case .failure(let error):
                    print("Error fetching sensor data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let user = selectedUser {
            configureCenteredNavBar(title: user.user_name, subtitle: user.helmet.helmet_serial_number)
        }
    }
}
