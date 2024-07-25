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

    func userDidLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Configura el primer UINavigationController
        let firstViewController = storyboard.instantiateViewController(withIdentifier: "ScrollViewUserSensorsViewController") as! ScrollViewUserSensorsViewController
        let firstNavController = UINavigationController(rootViewController: firstViewController)
        firstNavController.tabBarItem = UITabBarItem(title: "Sensores", image: UIImage(named: "list.png"), tag: 0)
        
        // Configura el segundo UINavigationController
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "CRUDViewController")
        let secondNavController = UINavigationController(rootViewController: secondViewController)
        secondNavController.tabBarItem = UITabBarItem(title: "CRUD", image: UIImage(systemName: ""), tag: 1)
        
        // Configura el tercer UINavigationController
        let thirdViewController = storyboard.instantiateViewController(withIdentifier: "ScrollViewUserSensorsViewController") as! ScrollViewUserSensorsViewController
        let thirdNavController = UINavigationController(rootViewController: thirdViewController)
        thirdNavController.tabBarItem = UITabBarItem(title: "Usuarios", image: UIImage(systemName: ""), tag: 2)
        
        // Configura UITabBarController
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstNavController, secondNavController, thirdNavController]
        
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        
        if let window = window {
            window.rootViewController = tabBarController
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }

}
