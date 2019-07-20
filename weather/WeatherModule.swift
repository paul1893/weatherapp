import UIKit

class WeatherModule {
    static var router: Router!
    
    static func listViewController() -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ListViewController.self)) as! ListViewController
        viewController.interactor = WeatherInteractor(
            repository: WeatherRepositoryImpl(with: CallerImpl(), with: WeatherParser()),
            localRepository: LocalWeatherRepositoryImpl(),
            presenter: WeatherPresenterImpl(view: viewController),
            deviceManager: DeviceManagerImpl(),
            router: router
        )
        return viewController
    }
    
    static func weatherDetailViewController(_ id: Int) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: WeatherDetailViewController.self)) as! WeatherDetailViewController
        viewController.id = id
        viewController.interactor = WeatherDetailInteractor(
            localRepository: LocalWeatherRepositoryImpl(),
            presenter: WeatherDetailPresenterImpl(view: viewController)
        )
        return viewController
    }
}
