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

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func userDidLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
        // Primer UINavigationController
        let firstViewController = storyboard.instantiateViewController(withIdentifier: "ScrollViewUserSensorsViewController") as! ScrollViewUserSensorsViewController
        let firstNavController = UINavigationController(rootViewController: firstViewController)
        firstNavController.tabBarItem = UITabBarItem(title: "Usuarios", image: UIImage(named: "list.png"), tag: 0)

        // Segundo UINavigationController
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "CRUDViewController")
        let secondNavController = UINavigationController(rootViewController: secondViewController)
        secondNavController.tabBarItem = UITabBarItem(title: "CRUD", image: UIImage(systemName: ""), tag: 1)

        // Tercer UINavigationController
        let thirdViewController = UIViewController()
        thirdViewController.view.backgroundColor = .blue
        let thirdNavController = UINavigationController(rootViewController: thirdViewController)
        thirdNavController.tabBarItem = UITabBarItem(title: "More", image: UIImage(systemName: ""), tag: 2)

        // Configurar UITabBarController
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
