import Foundation

class WeatherDetailInteractor {
    private let localRepository: LocalWeatherRepository
    private let presenter: WeatherDetailPresenter
    private let executor: Executor
    
    init(
        localRepository: LocalWeatherRepository,
        presenter: WeatherDetailPresenter,
        executor: Executor = Executor()
        ) {
        self.localRepository = localRepository
        self.presenter = presenter
        self.executor = executor
    }
    
    func getWeather(id: Int) {
        executor.run {
            if let weather = self.localRepository.getSavedWeatherList().filter({ (weather) -> Bool in
                weather.timestamp == id
            }).first {
                self.presenter.presentWeather(with: weather)
            } else {
                self.presenter.presentError()
            }
        }
    }
}

