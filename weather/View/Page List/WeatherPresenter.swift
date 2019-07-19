import Foundation

protocol WeatherPresenter {
    func presentError()
    func presentWeather(with weatherList: [Weather])
}

protocol WeatherListView : class {
    func showError(message: String)
    func showWeather(with model: [WeatherViewModel])
}

class WeatherPresenterImpl : WeatherPresenter {
    private weak var view : WeatherListView?
    
    init(view: WeatherListView) {
        self.view = view
    }
    
    func presentError() {
        view?.showError(message:
            "Something went wrong cannot get the weather".localized
        )
    }
    
    func presentWeather(with weatherList: [Weather]) {
        view?.showWeather(with: weatherList.map({ (weather) -> WeatherViewModel in
            return WeatherViewModel(temperature: "\(weather.temperature - 273.15) °C")
        }))
    }
}
