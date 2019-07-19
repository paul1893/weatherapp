import UIKit

class ListViewController: UIViewController, WeatherListView {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let interactor = WeatherInteractor(
            repository: WeatherRepositoryImpl(with: CallerImpl(), with: WeatherParser()),
            presenter: WeatherPresenterImpl(view: self)
        )
        interactor.getWeatherList()
    }
    
    func showError(message: String) {}
    
    func showWeather(with model: [WeatherViewModel]) {}

}

