import UIKit
import MapKit

class GPSViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblLatitud: UILabel!
    @IBOutlet weak var lblLongitud: UILabel!
    @IBOutlet weak var lblAltitud: UILabel!
    @IBOutlet weak var lblPresion: UILabel!
    
    var selectedUser: User?
    var latitud: Double?
    var longitud: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configura el mapa
        // Imprime la información del usuario para verificar que se ha recibido correctamente
        if let user = selectedUser {
            print("User Name: \(user.user_name)")
            print("User Email: \(user.email)")
            print("Helmet Serial Number: \(user.helmet.helmet_serial_number)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = selectedUser {
            configureCenteredNavBar(title: user.user_name, subtitle: user.helmet.helmet_serial_number)
            
            // Llamar a fetchSensorData desde ApiService
            ApiService.shared.fetchSensorData(helmetId: user.helmet.helmet_serial_number, sensorType: "gps-latitud") { result in
                DispatchQueue.main.async { // Asegúrate de que esto se ejecute en el hilo principal
                    switch result {
                    case .success(let sensorData):
                        print("Sensor Data: \(sensorData)")
                        self.lblLatitud.text = String(sensorData.latest_value)
                        self.latitud = sensorData.latest_value
                    case .failure(let error):
                        print("Error fetching sensor data: \(error.localizedDescription)")
                    }
                }
            }
            ApiService.shared.fetchSensorData(helmetId: user.helmet.helmet_serial_number, sensorType: "gps-longitud") { result in
                DispatchQueue.main.async { // Asegúrate de que esto se ejecute en el hilo principal
                    switch result {
                    case .success(let sensorData):
                        print("Sensor Data: \(sensorData)")
                        self.lblLongitud.text = String(sensorData.latest_value)
                        self.longitud = sensorData.latest_value
                    case .failure(let error):
                        print("Error fetching sensor data: \(error.localizedDescription)")
                    }
                }
            }
            ApiService.shared.fetchSensorData(helmetId: user.helmet.helmet_serial_number, sensorType: "altitud") { result in
                DispatchQueue.main.async { // Asegúrate de que esto se ejecute en el hilo principal
                    switch result {
                    case .success(let sensorData):
                        print("Sensor Data: \(sensorData)")
                        self.lblAltitud.text = String(sensorData.latest_value)
                    case .failure(let error):
                        print("Error fetching sensor data: \(error.localizedDescription)")
                    }
                }
            }
            configureMapView()
        }
    }

    private func configureMapView() {
        // Ejemplo de configuración básica
        let coordinate = CLLocationCoordinate2D(latitude: latitud ?? 0, longitude: longitud ?? 0) // Coordenadas de ejemplo
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        mapView.setRegion(region, animated: true)
    }
}
