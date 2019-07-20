import Foundation

struct Weather : Equatable {
    var timestamp: String
    var date: String
    var temperature: Float
    var rain: Float
    var humidity: Float
    var windAverage: Float
    var windBurst: Float
    var windDirection: Float
    var snow: Bool
    
    init(
        timestamp: String,
        date: String,
        temperature: Float,
        rain: Float,
        humidity: Float,
        windAverage: Float,
        windBurst: Float,
        windDirection: Float,
        snow: Bool
        ) {
        self.timestamp = timestamp
        self.date = date
        self.temperature = temperature
        self.rain = rain
        self.humidity = humidity
        self.windAverage = windAverage
        self.windBurst = windBurst
        self.windDirection = windDirection
        self.snow = snow
    }
}
