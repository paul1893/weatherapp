import Foundation

struct WeatherViewModel : Equatable {
    let timestamp : Int
    let date : String
    
    init(timestamp: Int, date: String) {
        self.timestamp = timestamp
        self.date = date
    }
}
