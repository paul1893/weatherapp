import Foundation
import SwiftyJSON

protocol Parser {
    func parse(_ data: Data) throws -> [WeatherJSON?]
}

class WeatherParser : Parser {
    func parse(_ data: Data) throws -> [WeatherJSON?] {
        do {
            return try JSON(data: data).dictionaryValue.map({(arg0) -> WeatherJSON? in
                if let date = arg0.key.toTimestamp(),
                    let temperature = arg0.value["temperature"]["sol"].float
                {
                    return WeatherJSON(withDate: date, withTemperature: temperature)
                } else {
                    return nil
                }
            })
        } catch  {
            throw WeatherError.parsingError
        }
    }
}

class WeatherJSON {
    var date: Int
    var temperature: Float
    
    init(withDate date: Int, withTemperature temperature: Float) {
        self.date = date
        self.temperature = temperature
    }
}
