import UIKit

class ScrollViewUserSensorsViewController: UIViewController {
    @IBOutlet weak var scrUsersSensors: UIScrollView!
    @IBOutlet weak var viewTop: UIView!
    
    
    private let viewContent = UIView()
    private let customTransitioningDelegate = CustomTransitioningDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewContent()
        addUserViews()
    }
    
    func setUpViewContent() {
        scrUsersSensors.addSubview(viewContent)
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewContent.leadingAnchor.constraint(equalTo: scrUsersSensors.leadingAnchor),
            viewContent.trailingAnchor.constraint(equalTo: scrUsersSensors.trailingAnchor),
            viewContent.topAnchor.constraint(equalTo: scrUsersSensors.topAnchor),
            viewContent.bottomAnchor.constraint(equalTo: scrUsersSensors.bottomAnchor),
            viewContent.widthAnchor.constraint(equalTo: scrUsersSensors.widthAnchor)
        ])
    }
    
    func addUserViews() {
        let numberOfUsers = 9
        
        for i in 0..<numberOfUsers {
            let userView = UIView()
            userView.makeRoundView(cornerRadius: 10.0)
            userView.backgroundColor = .systemMint
            userView.translatesAutoresizingMaskIntoConstraints = false
            viewContent.addSubview(userView)
            
            let imageView = UIImageView()
            imageView.image = UIImage(named: "user.png")
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            userView.addSubview(imageView)
            
            let label = UILabel()
            label.text = "User \(i + 1)"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            userView.addSubview(label)
            
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = i // Si necesitas identificar el botón más tarde
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            userView.addSubview(button)
            
            let row = i / 2
            let column = i % 2
            
            NSLayoutConstraint.activate([
                userView.widthAnchor.constraint(equalTo: scrUsersSensors.widthAnchor, multiplier: 0.4),
                userView.heightAnchor.constraint(equalTo: userView.widthAnchor, multiplier: 1.0),
                column == 0 ?
                    userView.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: 20) :
                    userView.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: -20),
                userView.topAnchor.constraint(equalTo: row == 0 ? viewContent.topAnchor : viewContent.subviews[(row * 2) - 1].bottomAnchor, constant: 20),
                
                imageView.centerXAnchor.constraint(equalTo: userView.centerXAnchor),
                imageView.topAnchor.constraint(equalTo: userView.topAnchor, constant: 20.0),
                imageView.widthAnchor.constraint(equalTo: userView.widthAnchor, multiplier: 0.5),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
                
                label.leadingAnchor.constraint(equalTo: userView.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: userView.trailingAnchor),
                label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10.0),
                
                button.topAnchor.constraint(equalTo: userView.topAnchor),
                button.bottomAnchor.constraint(equalTo: userView.bottomAnchor),
                button.leadingAnchor.constraint(equalTo: userView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: userView.trailingAnchor)
            ])
            
            if i == numberOfUsers - 1 {
                userView.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: -20).isActive = true
            }
        }
    }
    
    //PENDIENTE - Mantener el tabbar en todo el flujo de navegación de cada item
    @objc func buttonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let sensorsViewController = storyboard.instantiateViewController(withIdentifier: "SensorsViewController") as? SensorsViewController {
            sensorsViewController.modalPresentationStyle = .fullScreen
            sensorsViewController.transitioningDelegate = customTransitioningDelegate
            self.present(sensorsViewController, animated: true, completion: nil)
        }
    }
}
