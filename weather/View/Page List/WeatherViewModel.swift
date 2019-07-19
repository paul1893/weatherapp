import Foundation

struct WeatherViewModel : Equatable {
    let temperature : String
    
    init(temperature: String) {
        self.temperature = temperature
    }
}
