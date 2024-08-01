// UIViewExtensions.swift
import UIKit

extension UIView {
    func makeRoundView(cornerRadius: CGFloat? = nil) {
        if let radius = cornerRadius {
            self.layer.cornerRadius = radius
        } else {
            self.layer.cornerRadius = self.frame.size.width / 2.0
        }
        self.clipsToBounds = true
    }
}

extension UIButton {
    func makeRoundButton(cornerRadius: CGFloat? = nil) {
        if let radius = cornerRadius {
            self.layer.cornerRadius = radius
        } else {
            self.layer.cornerRadius = self.frame.size.width / 2.0
        }
        self.clipsToBounds = true
    }
}

extension UILabel {
    func adjustFontSize() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let scaleFactor = height / 900.0
        self.font = self.font.withSize(self.font.pointSize * scaleFactor)
    }
}

extension UIViewController {
    func configureCustomNavigationBar(title: String, subtitle: String) {
        // Crear la vista personalizada para la barra de navegación
        let customTitleView = UIView()
        customTitleView.frame = CGRect(x: 0, y: 0, width: 200, height: 60)

        // Crear y configurar la imagen
        let imageView = UIImageView(image: UIImage(named: "user.png"))
        imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        customTitleView.addSubview(imageView)

        // Crear y configurar las etiquetas
        let topLabel = UILabel()
        topLabel.text = title
        topLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        topLabel.textColor = .white
        topLabel.frame = CGRect(x: 50, y: 0, width: 150, height: 20)
        customTitleView.addSubview(topLabel)

        let bottomLabel = UILabel()
        bottomLabel.text = subtitle
        bottomLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        bottomLabel.textColor = .white
        bottomLabel.frame = CGRect(x: 50, y: 20, width: 150, height: 20)
        customTitleView.addSubview(bottomLabel)

        // Configurar el titleView de la barra de navegación
        self.navigationItem.titleView = customTitleView
    }
    
    func configureCenteredNavBar(title: String, subtitle: String) {
        // Configura la barra de navegación para usar títulos grandes
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .never

        // Crear la vista personalizada para la barra de navegación
        let customTitleView = UIView()
        customTitleView.translatesAutoresizingMaskIntoConstraints = false
        customTitleView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        // No fijar altura, dejar que se ajuste dinámicamente

        // Crear y configurar las etiquetas
        let topLabel = UILabel()
        topLabel.text = title
        topLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        topLabel.textColor = .white
        topLabel.textAlignment = .center
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        customTitleView.addSubview(topLabel)

        let bottomLabel = UILabel()
        bottomLabel.text = subtitle
        bottomLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        bottomLabel.textColor = .white
        bottomLabel.textAlignment = .center
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        customTitleView.addSubview(bottomLabel)

        // Agregar restricciones para centrar las etiquetas en la vista
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: customTitleView.centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: customTitleView.topAnchor),
            topLabel.widthAnchor.constraint(equalTo: customTitleView.widthAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 20),

            bottomLabel.centerXAnchor.constraint(equalTo: customTitleView.centerXAnchor),
            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 2),
            bottomLabel.widthAnchor.constraint(equalTo: customTitleView.widthAnchor),
            bottomLabel.heightAnchor.constraint(equalToConstant: 20),
            bottomLabel.bottomAnchor.constraint(equalTo: customTitleView.bottomAnchor) // Ajustar esto para usar el espacio restante
        ])

        // Configurar el titleView de la barra de navegación
        self.navigationItem.titleView = customTitleView
    }

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alerta = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Aceptar", style: .default) { _ in
            completion?()
        }
        alerta.addAction(ok)
        present(alerta, animated: true, completion: nil)
    }
}
