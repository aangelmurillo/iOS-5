import UIKit
import WebKit

class CameraViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var viewCamera: UIView!
    
    var selectedUser: User?
    var webView: WKWebView!
    var retryLabel: UILabel!
    var retryTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = selectedUser {
            print("User Name: \(user.user_name)")
            print("User Email: \(user.email)")
            let serialNumber = user.helmet?.helmet_serial_number ?? "nil"
            print("Helmet Serial Number: \(serialNumber)")
        }
        
        setupWebView()
        setupRetryLabel()
        loadLiveStream()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = selectedUser {
            let serialNumber = user.helmet?.helmet_serial_number ?? "nil"
            configureCenteredNavBar(title: user.user_name, subtitle: serialNumber)
        }
    }
    
    private func setupWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.viewCamera.addSubview(webView)
        
        // Añadir restricciones para que webView ocupe toda el área de viewCamera
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: self.viewCamera.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.viewCamera.trailingAnchor),
            webView.topAnchor.constraint(equalTo: self.viewCamera.topAnchor),
            webView.bottomAnchor.constraint(equalTo: self.viewCamera.bottomAnchor)
        ])
    }
    
    private func setupRetryLabel() {
        retryLabel = UILabel()
        retryLabel.text = "Cámara no encontrada... Reintentando..."
        retryLabel.textAlignment = .center
        retryLabel.textColor = .red
        retryLabel.translatesAutoresizingMaskIntoConstraints = false
        retryLabel.isHidden = true
        self.viewCamera.addSubview(retryLabel)
        
        // Añadir restricciones para centrar el label en viewCamera
        NSLayoutConstraint.activate([
            retryLabel.centerXAnchor.constraint(equalTo: self.viewCamera.centerXAnchor),
            retryLabel.centerYAnchor.constraint(equalTo: self.viewCamera.centerYAnchor)
        ])
    }
    
    private func loadLiveStream() {
        if let url = URL(string: "https://ihelmet-octavio.loca.lt/") {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            print("Invalid URL")
        }
    }
    
    private func retryLoading() {
        print("Reintentando cargar la cámara...")
        retryLabel.isHidden = false
        loadLiveStream()
    }

    private func startRetryTimer() {
        stopRetryTimer()
        retryTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.retryLoading()
        }
    }
    
    private func stopRetryTimer() {
        retryTimer?.invalidate()
        retryTimer = nil
    }

    // WKNavigationDelegate methods
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Error provisional: \(error.localizedDescription)")
        retryLoading()
        startRetryTimer()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Error de navegación: \(error.localizedDescription)")
        retryLoading()
        startRetryTimer()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        retryLabel.isHidden = true
        stopRetryTimer()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse, response.statusCode == 404 {
            print("Error 404: Cámara no encontrada")
            retryLoading()
            startRetryTimer()
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
