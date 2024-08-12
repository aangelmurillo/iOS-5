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
    var timer: Timer? // Timer para las peticiones

    // Array para almacenar las anotaciones en el mapa
    private var annotations = [MKPointAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Configura el mapa
        if let user = selectedUser {
            print("User Name: \(user.user_name)")
            print("User Email: \(user.email)")
            let serialNumber = user.helmet?.helmet_serial_number ?? "nil"
            print("Helmet Serial Number: \(serialNumber)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = selectedUser {
            let serialNumber = user.helmet?.helmet_serial_number ?? "nil"
            configureCenteredNavBar(title: user.user_name, subtitle: serialNumber)
            
            // Realiza la primera petición inmediatamente
            fetchSensorDataForAllTypes()
            
            // Inicia el timer para peticiones periódicas
            startFetchingSensorData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopFetchingSensorData() // Detiene el timer cuando la vista desaparece
    }
    
    private func startFetchingSensorData() {
        // Inicia un timer para llamar a fetchSensorDataForAllTypes cada 5 segundos
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.fetchSensorDataForAllTypes()
        }
    }
    
    private func stopFetchingSensorData() {
        // Detiene el timer cuando la vista desaparece
        timer?.invalidate()
        timer = nil
    }
    
    private func fetchSensorDataForAllTypes() {
        guard (selectedUser?.helmet?.helmet_serial_number) != nil else { return }
        let sensorTypes = ["gps-latitud", "gps-longitud", "altitud", "presion"]
        
        for sensorType in sensorTypes {
            fetchAndSetSensorData(sensorType: sensorType)
        }
    }
    
    private func fetchAndSetSensorData(sensorType: String) {
        guard let helmetId = selectedUser?.helmet?.helmet_serial_number else { return }
        ApiService.shared.fetchSensorData(helmetId: helmetId, sensorType: sensorType) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sensorData):
                    let sensorValue = sensorData.latest_value
                    self?.updateUI(for: sensorType, with: sensorValue)
                    // Solo imprimir latitud y longitud en la terminal
                    if sensorType == "gps-latitud" {
                        print("Latitud actual: \(sensorValue)")
                    } else if sensorType == "gps-longitud" {
                        print("Longitud actual: \(sensorValue)")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error obteniendo los datos del sensor", message: "No se pudo obtener las coordenadas")
                    }
                    print("Error fetching sensor data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func updateUI(for sensorType: String, with value: Double) {
        switch sensorType {
        case "gps-latitud":
            self.latitud = value
            self.lblLatitud.text = self.convertToDMS(coordinate: value, isLatitude: true)
            self.updateMapViewIfNeeded()
        case "gps-longitud":
            self.longitud = value
            self.lblLongitud.text = self.convertToDMS(coordinate: value, isLatitude: false)
            self.updateMapViewIfNeeded()
        case "altitud":
            self.lblAltitud.text = "\(value) m"
        case "presion":
            self.lblPresion.text = "\(value) hPa"
        default:
            break
        }
    }
    
    private func updateMapViewIfNeeded() {
        guard let latitud = latitud, let longitud = longitud else {
            return // Esperar a tener ambas coordenadas
        }
        configureMapView(latitude: latitud, longitude: longitud)
    }

    private func configureMapView(latitude: Double, longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        // Elimina todas las anotaciones existentes
        mapView.removeAnnotations(annotations)
        
        // Crea una nueva anotación
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Ubicación actual"
        
        // Añade la nueva anotación
        annotations.append(annotation)
        mapView.addAnnotation(annotation)
    }
    
    // Función para convertir coordenadas decimales a DMS (grados, minutos, segundos)
    private func convertToDMS(coordinate: Double, isLatitude: Bool) -> String {
        let degrees = Int(coordinate)
        let minutesDecimal = abs(coordinate - Double(degrees)) * 60
        let minutes = Int(minutesDecimal)
        let seconds = (minutesDecimal - Double(minutes)) * 60
        
        let direction: String
        if isLatitude {
            direction = degrees >= 0 ? "N" : "S"
        } else {
            direction = degrees >= 0 ? "E" : "O"
        }
        
        return String(format: "%d°%d'%0.2f\"%@", abs(degrees), minutes, seconds, direction)
    }
}
