import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .systemBlue
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .darkGray
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .white // Color for selected item
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white] // Color for selected item
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
        
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    func userDidLogin(role_id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if role_id == 1 {
            // Configura el primer UINavigationController para Administrador
            let firstViewController = storyboard.instantiateViewController(withIdentifier: "ScrollViewUserSensorsViewController") as! ScrollViewUserSensorsViewController
            firstViewController.tabIdentifier = 0 // Establece el identificador
            let firstNavController = UINavigationController(rootViewController: firstViewController)
            firstNavController.tabBarItem = UITabBarItem(title: "Sensores", image: UIImage(named: "list.png"), tag: 0)
            
            // Configura el segundo UINavigationController para Administrador
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "CrudBtnsViewController")
            let secondNavController = UINavigationController(rootViewController: secondViewController)
            secondNavController.tabBarItem = UITabBarItem(title: "Registrar", image: UIImage(systemName: "square.and.pencil"), tag: 1)
            
            // Configura el tercer UINavigationController para Administrador
            let thirdViewController = storyboard.instantiateViewController(withIdentifier: "ScrollViewUserSensorsViewController") as! ScrollViewUserSensorsViewController
            thirdViewController.tabIdentifier = 2 // Establece el identificador
            let thirdNavController = UINavigationController(rootViewController: thirdViewController)
            thirdNavController.tabBarItem = UITabBarItem(title: "Información", image: UIImage(systemName: "info.circle"), tag: 2)
            
            // Configura UITabBarController para Administrador
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [firstNavController, secondNavController, thirdNavController]
            
            tabBarController.tabBar.tintColor = .white
            tabBarController.tabBar.unselectedItemTintColor = .lightGray
            
            if let window = window {
                window.rootViewController = tabBarController
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
        } else if role_id == 2 {
            // Configura el primer UINavigationController para Empleado
            let firstViewController = storyboard.instantiateViewController(withIdentifier: "SensorsViewController") as! SensorsViewController
            let firstNavController = UINavigationController(rootViewController: firstViewController)
            firstNavController.tabBarItem = UITabBarItem(title: "Sensores", image: UIImage(named: "list.png"), tag: 0)
            
            // Configura el segundo UINavigationController para Empleado
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "InfoButtonsViewController") as! InfoButtonsViewController
            let secondNavController = UINavigationController(rootViewController: secondViewController)
            secondNavController.tabBarItem = UITabBarItem(title: "Información", image: UIImage(systemName: "info.circle"), tag: 1)
            
            // Configura UITabBarController para Empleado
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [firstNavController, secondNavController]
            
            tabBarController.tabBar.tintColor = .white
            tabBarController.tabBar.unselectedItemTintColor = .lightGray
            
            if let window = window {
                window.rootViewController = tabBarController
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
        }
    }
}
