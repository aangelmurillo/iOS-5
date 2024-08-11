import UIKit

class PersonalHelmetViewController: UIViewController {
    @IBOutlet weak var dpkFecha: UIDatePicker!
    @IBOutlet weak var lblPresionMax: UILabel!
    @IBOutlet weak var lblTemperaturaMax: UILabel!
    @IBOutlet weak var lblHumedadMax: UILabel!
    @IBOutlet weak var lblAltitudMax: UILabel!
    @IBOutlet weak var lblPresionMin: UILabel!
    @IBOutlet weak var lblTemperaturaMin: UILabel!
    @IBOutlet weak var lblHumedadMin: UILabel!
    @IBOutlet weak var lblAltitudMin: UILabel!
    
    var selectedUser: User?
    
    // Array que contiene todos los labels
    private var allLabels: [UILabel] {
        return [lblPresionMax, lblTemperaturaMax, lblHumedadMax, lblAltitudMax,
                lblPresionMin, lblTemperaturaMin, lblHumedadMin, lblAltitudMin]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura el target del UIDatePicker para llamar a `dateChanged` cuando cambie el valor
        dpkFecha.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // Ajusta el tamaño de la fuente de todos los labels
        adjustAllLabelFonts()
        
        // Inicializa la vista con la fecha actual
        updateStatsForDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = selectedUser {
            let serialNumber = user.helmet?.helmet_serial_number ?? "nil"
            configureCenteredNavBar(title: user.user_name, subtitle: serialNumber)
        }
        
        dpkFecha.maximumDate = Date()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        updateStatsForDate()
    }
    
    func formatDatePickerDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        return formatter.string(from: date)
    }
    
    func updateStatsForDate() {
        let dateString = formatDatePickerDate(dpkFecha.date)
        let helmetID = selectedUser?.helmet?.helmet_serial_number ?? "No se encuentra"
        
        ApiService.shared.fetchPersonalHelmetStats(date: dateString, helmetID: helmetID) { response in
            DispatchQueue.main.async {
                if let response = response {
                    print("Estado: \(response.status)")
                    print("Datos: \(response.data)")
                    self.updateLabels(with: response.data)
                } else {
                    print("No se pudo obtener la respuesta de la API")
                }
            }
        }
    }
    
    func updateLabels(with stats: Stats) {
        lblTemperaturaMax.text = "Max: \(stats.temperatura.max ?? 0) °C"
        lblPresionMax.text = "Max: \(stats.presion.max ?? 0) ATM"
        lblHumedadMax.text = "Max: \(stats.humedad.max ?? 0) %"
        lblAltitudMax.text = "Max: \(stats.altitud.max ?? 0) m"
        lblTemperaturaMin.text = "Min: \(stats.temperatura.min ?? 0) °C"
        lblPresionMin.text = "Min: \(stats.presion.min ?? 0) ATM"
        lblHumedadMin.text = "Min: \(stats.humedad.min ?? 0) %"
        lblAltitudMin.text = "Min: \(stats.altitud.min ?? 0) m"
    }
    
    func adjustAllLabelFonts() {
        // Ajusta el tamaño de la fuente para cada label en el array
        allLabels.forEach { $0.adjustFontSize() }
    }
}
