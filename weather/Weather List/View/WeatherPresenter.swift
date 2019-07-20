import Foundation

protocol WeatherPresenter {
    func presentError()
    func presentOutdatedData()
    func presentWeather(with weatherList: [Weather])
}

protocol WeatherListView : class {
    func showError(message: String)
    func showWeather(with modelList: [WeatherViewModel])
    func showEmptyWeather()
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
    
    func presentOutdatedData() {
        executor.runOnMain {
            self.view?.showError(message:
                "This is offline data, they must be outdated".localized
            )
        }
    }
    
    func presentWeather(with weatherList: [Weather]) {
        if weatherList.count == 0 {
            executor.runOnMain {
                self.view?.showEmptyWeather()
            }
        } else {
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
}
