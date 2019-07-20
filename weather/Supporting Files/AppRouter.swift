import UIKit

protocol Router {
    func go(to: Link)
}

enum Link: Equatable {
    case weatherDetail(id: String)
}

class AppRouter {
    var navigationController: UINavigationController!
    
    func rootViewController() -> UINavigationController {
        navigationController = UINavigationController(rootViewController: WeatherModule.listViewController())
        navigationController.navigationBar.prefersLargeTitles = false
        return navigationController
    }
    
    fileprivate func showWeatherDetail(_ id: String) {
        let viewController = WeatherModule.weatherDetailViewController(id)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AppRouter: Router {
    func go(to link: Link) {
        switch link {
            case .weatherDetail(let id): showWeatherDetail(id)
        }
    }
}
