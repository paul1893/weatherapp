import Foundation

class Weather : Equatable {
    var temperature: Float
    
    init(temperature: Float) {
        self.temperature = temperature
    }

    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.temperature == rhs.temperature
    }
}
