struct WeatherDetailViewModel : Equatable {
    var date: String
    var temperature: String
    var rain: String
    var humidity: String
    var windAverage: String
    var windBurst: String
    var windDirection: String
    
    init(
        date: String,
        temperature: String,
        rain: String,
        humidity: String,
        windAverage: String,
        windBurst: String,
        windDirection: String
        ) {
        self.date = date
        self.temperature = temperature
        self.rain = rain
        self.humidity = humidity
        self.windAverage = windAverage
        self.windBurst = windBurst
        self.windDirection = windDirection
    }
}
