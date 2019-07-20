import Foundation

class WeatherInteractor {
    private let repository: WeatherRepository
    private let presenter: WeatherPresenter
    private let executor: Executor
    
    init(repository : WeatherRepository, presenter: WeatherPresenter, executor: Executor = Executor()) {
        self.repository = repository
        self.presenter = presenter
        self.executor = executor
    }
    
    func getWeatherList() {
        executor.run {
            do {
                let weatherList = try self.repository.getWeather()
                self.presenter.presentWeather(with: weatherList)
            } catch {
                self.presenter.presentError()
            }
        }
    }
}
