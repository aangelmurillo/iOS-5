import UIKit

class TemperatureViewController: UIViewController {
    @IBOutlet var lblsTemperatura: [UILabel]!
    @IBOutlet weak var viewTemperatura: UIView!
    
    var selectedUser: User?
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        adjustFontSizeForAllLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTemperatureData() // Realiza la primera petición inmediatamente
        startFetchingTemperatureData() // Luego inicia el timer
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopFetchingTemperatureData() // Detiene el timer cuando la vista desaparece
    }
    
    private func setupView() {
        guard let user = selectedUser else {
            configureCenteredNavBar(title: "Usuario no disponible", subtitle: "No disponible")
            return
        }
        let serialNumber = user.helmet?.helmet_serial_number ?? "No disponible"
        configureCenteredNavBar(title: user.user_name, subtitle: serialNumber)
    }
    
    private func startFetchingTemperatureData() {
        // Inicia un timer para llamar a fetchTemperatureData cada 5 segundos
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.fetchTemperatureData()
        }
    }
    
    private func stopFetchingTemperatureData() {
        // Detiene el timer cuando la vista desaparece
        timer?.invalidate()
        timer = nil
    }
    
    private func fetchTemperatureData() {
        guard let user = selectedUser, let helmetId = user.helmet?.helmet_serial_number else {
            print("No se puede obtener los datos de temperatura. Usuario o casco no disponible.")
            return
        }
        ApiService.shared.fetchSensorData(helmetId: helmetId, sensorType: "temperatura") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sensorData):
                    self?.updateTemperatureLabels(with: sensorData.latest_value)
                    // Aquí se asume que sensorData tiene una propiedad name
                    let sensorName = sensorData.sensor // Asegúrate de que `name` esté disponible
                    let sensorValue = sensorData.latest_value
                    print("Petición realizada a las \(Date()) - Sensor: \(sensorName), Valor: \(sensorValue)")
                case .failure(let error):
                    print("Error fetching sensor data: \(error.localizedDescription)")
                }
            }
        }
    }

    private func updateTemperatureLabels(with celsius: Double) {
        updateLabelWithTag(1, text: String(format: "%.2f °C", celsius))
        updateLabelWithTag(2, text: String(format: "%.2f °F", convertToFahrenheit(celsius: celsius)))
        updateLabelWithTag(3, text: String(format: "%.2f K", convertToKelvin(celsius: celsius)))
        updateWarningLabels(for: celsius)
    }
    
    private func adjustFontSizeForAllLabels() {
        lblsTemperatura.forEach { $0.adjustFontSize() }
    }
    
    private func updateLabelWithTag(_ tag: Int, text: String) {
        if let label = lblsTemperatura.first(where: { $0.tag == tag }) {
            label.text = text
        }
    }
    
    private func convertToFahrenheit(celsius: Double) -> Double {
        return (celsius * 9/5) + 32
    }
    
    private func convertToKelvin(celsius: Double) -> Double {
        return celsius + 273.15
    }
    
    private func updateWarningLabels(for celsius: Double) {
        let (warning, desc) = getWarningAndDescription(for: celsius)
        updateLabelWithTag(5, text: warning)
        updateLabelWithTag(6, text: desc)
    }
    
    private func getWarningAndDescription(for celsius: Double) -> (String, String) {
        if celsius < 27 {
            viewTemperatura.backgroundColor = .systemGreen
            return ("Seguro", "La temperatura está dentro del rango normal.")
        } else if celsius <= 28 {
            viewTemperatura.backgroundColor = .systemOrange
            return ("Precaución", "La temperatura está aumentando. Tomar precauciones.")
        } else {
            viewTemperatura.backgroundColor = .systemRed
            return ("Peligro", "La temperatura ha superado el límite seguro.")
        }
    }
}
