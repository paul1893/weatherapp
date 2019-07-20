protocol WeatherDetailPresenter {
    func presentError()
    func presentWeather(with weather: Weather)
}

protocol WeatherDetailView : class {
    func showError()
    func showWeather(with model: WeatherDetailViewModel)
}

class WeatherDetailPresenterImpl : WeatherDetailPresenter {
    private weak var view : WeatherDetailView?
    private let executor: Executor
    
    init(view: WeatherDetailView, executor: Executor = Executor()) {
        self.view = view
        self.executor = executor
    }
    
    func presentError() {
        executor.runOnMain {
            self.view?.showError()
        }
    }
    
    func presentWeather(with weather: Weather) {
        let weatherDetailViewModel = WeatherDetailViewModel(
            date: weather.date,
            temperature: "\(Int(weather.temperature - 273.15)) °C",
            rain: "\(weather.rain) mm",
            humidity: "\(weather.humidity) %",
            windAverage: "\(weather.windAverage) km/h",
            windBurst: "\(weather.windBurst) km/h",
            windDirection: getDirection(weather.windDirection)
        )
        
        executor.runOnMain {
            self.view?.showWeather(with: weatherDetailViewModel)
        }
    }
    
    private func getDirection(_ direction: Float) -> String {
        if direction == 0 {
            return "East".localized
        } else if direction > 0 && direction < 90 {
            return "North-East".localized
        } else if direction == 90 {
            return "North".localized
        } else if direction > 90 && direction < 180 {
            return "North-West".localized
        } else if direction == 180 {
            return "West".localized
        } else if direction > 180 && direction < 270 {
            return "South-West".localized
        } else if direction == 270 {
            return "South".localized
        } else if direction > 270 && direction < 360 {
            return "South-East".localized
        } else {
            return "No direction".localized
        }
    }
}
