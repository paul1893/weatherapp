import Foundation

struct Weather : Equatable {
    var temperature: Float
    
    init(temperature: Float) {
        self.temperature = temperature
    }
}
