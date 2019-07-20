import Foundation

protocol WeatherPresenter {
    func presentError()
    func presentWeather(with weatherList: [Weather])
}

protocol WeatherListView : class {
    func showError(message: String)
    func showWeather(with modelList: [WeatherViewModel])
}

class WeatherPresenterImpl : WeatherPresenter {
    private weak var view : WeatherListView?
    private let executor: Executor
    
    init(view: WeatherListView, executor: Executor = Executor()) {
        self.view = view
        self.executor = executor
    }
    
    func presentError() {
        executor.runOnMain {
            self.view?.showError(message:
                "Something went wrong cannot get the weather".localized
            )
        }
    }
    
    func presentWeather(with weatherList: [Weather]) {
        let weatherViewModelList = weatherList.map({ (weather) -> WeatherViewModel in
            return WeatherViewModel(
                timestamp: weather.timestamp,
                date: weather.date
            )
        })
        
        executor.runOnMain {
            self.view?.showWeather(with: weatherViewModelList)
        }
    }
}
