import UIKit

class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController = {
        let navVC = UINavigationController()
        let navigationBar = navVC.navigationBar
        navigationBar.setBackgroundImage(UIImage(),
                                         for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor(red: 233.0/255.0,
                                             green: 55.0/255.0,
                                             blue: 72.0/255.0,
                                             alpha: 1.0)
        navigationBar.barTintColor = UIColor(red: 233.0/255.0,
                                             green: 55.0/255.0,
                                             blue: 72.0/255.0,
                                             alpha: 1.0)
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 28)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationBar.isTranslucent = false
        return navVC
    }()
    
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let searchCityCoordinator = SearchCityCoordinator(navigationControler: navigationController)
        self.add(coordinator: searchCityCoordinator)
        searchCityCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
