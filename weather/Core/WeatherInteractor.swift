import Foundation

class WeatherInteractor {
    private let repository: WeatherRepository
    private let localRepository: LocalWeatherRepository
    private let presenter: WeatherPresenter
    private let router: Router
    private let executor: Executor
    
    init(
        repository : WeatherRepository,
        localRepository: LocalWeatherRepository,
        presenter: WeatherPresenter,
        router: Router,
        executor: Executor = Executor()
        ) {
        self.repository = repository
        self.localRepository = localRepository
        self.presenter = presenter
        self.router = router
        self.executor = executor
    }
    
    func getWeatherList(latitude: Double, longitude: Double) {
        executor.run {
            do {
                let weatherList = try self.repository.getWeather(withLatitude: latitude, withLongitude: longitude)
                self.localRepository.deleteWeatherList()
                self.localRepository.saveWeatherList(list: weatherList)
                self.presenter.presentWeather(with: weatherList)
            } catch {
                self.presenter.presentError()
            }
        }
    }
    
    func selectRow(withId id: Int) {
        router.go(to: Link.weatherDetail(id: id))
    }
}
