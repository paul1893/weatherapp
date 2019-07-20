import Foundation

struct WeatherViewModel : Equatable {
    let timestamp : String
    let date : String
    
    init(timestamp: String, date: String) {
        self.timestamp = timestamp
        self.date = date
    }
}
