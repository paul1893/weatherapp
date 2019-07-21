import Foundation

struct WeatherListViewModel : Equatable {
    let header: WeatherHeaderViewModel
    let list: [WeatherViewModel]
    
    init(header: WeatherHeaderViewModel, list: [WeatherViewModel]) {
        self.header = header
        self.list = list
    }
}

struct WeatherHeaderViewModel : Equatable {
    let temperature : String
    
    init(temperature: String) {
        self.temperature = temperature
    }
}

struct WeatherViewModel : Equatable {
    let timestamp : String
    let date : String
    
    init(timestamp: String, date: String) {
        self.timestamp = timestamp
        self.date = date
    }
}
