import UIKit
import MapKit

class GPSViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCenteredNavBar(title: "MURILLO", subtitle: "C000")

        // Configura el mapa
        configureMapView()
    }

    private func configureMapView() {
        // Ejemplo de configuración básica
        let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Coordenadas de ejemplo
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        mapView.setRegion(region, animated: true)
    }
}
