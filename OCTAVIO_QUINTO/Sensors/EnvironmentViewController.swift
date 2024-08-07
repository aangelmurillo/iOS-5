import UIKit

class EnvironmentViewController: UIViewController {

    @IBOutlet var lblsEnv: [UILabel]! // Usado para mostrar los valores de los sensores
    @IBOutlet var lblsEnvSensors: [UILabel]! // Usado para las etiquetas con tags del 0 al 2
    @IBOutlet weak var viewGases: UIView!
    @IBOutlet weak var viewTierra: UIView!
    @IBOutlet weak var viewHumedad: UIView!
    
    var selectedUser: User?
    var timer: Timer? // Timer para las peticiones

    override func viewDidLoad() {
        super.viewDidLoad()
        // Ajusta el tamaño de fuente de las etiquetas
        for lbl in lblsEnv {
            lbl.adjustFontSize()
        }
        for lbl in lblsEnvSensors {
            lbl.adjustFontSize()
        }

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
        guard let helmetId = selectedUser?.helmet?.helmet_serial_number else { return }
        let sensorTypes = ["mq2", "mq135", "fc28", "humedad"]

        for sensorType in sensorTypes {
            fetchAndSetSensorData(helmetId: helmetId, sensorType: sensorType)
        }
    }

    private func fetchAndSetSensorData(helmetId: String, sensorType: String) {
        ApiService.shared.fetchSensorData(helmetId: helmetId, sensorType: sensorType) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sensorData):
                    let sensorValue = sensorData.latest_value
                    self?.updateUI(for: sensorType, with: sensorValue)
                case .failure(let error):
                    print("Error fetching sensor data: \(error.localizedDescription)")
                }
            }
        }
    }

    private func updateUI(for sensorType: String, with value: Double) {
        switch sensorType {
        case "mq2", "mq135":
            let show = value == 1
            updateLabelTextAndColor(for: 0, text: show ? "Se han detectado gases peligrosos." : "No se detectan gases peligrosos.", color: show ? .systemRed : .systemGreen, view: viewGases)
        case "fc28":
            updateLabelTextAndColor(for: 1, text: value == 1 ? "La tierra está peligrosamente húmeda." : "La tierra está en buen estado.", color: value == 1 ? .systemRed : .systemGreen, view: viewTierra)
        case "humedad":
            let humidityText = "El porcentaje de humedad es: \(Int(value))%"
            updateLabelTextAndColor(for: 2, text: humidityText, color: getHumedadColor(value: value), view: viewHumedad)
        default:
            break
        }
    }

    private func updateLabelTextAndColor(for tag: Int, text: String, color: UIColor, view: UIView) {
        if let label = lblsEnvSensors.first(where: { $0.tag == tag }) {
            label.text = text
        } else {
            print("No label found with tag \(tag)")
        }
        view.backgroundColor = color
    }

    private func getHumedadColor(value: Double) -> UIColor {
        switch value {
        case ..<30:
            return .systemBlue
        case 30..<60:
            return .systemGreen
        case 60..<80:
            return .systemYellow
        case 80..<90:
            return .systemOrange
        case 90...:
            return .systemRed
        default:
            return .systemGray // Color de fallback si no se encuentra en el rango
        }
    }
}
