import Foundation
import SwiftyJSON

protocol Parser {
    func parse(_ data: Data) throws -> [WeatherJSON?]
}

class WeatherParser : Parser {
    func parse(_ data: Data) throws -> [WeatherJSON?] {
        do {
            return try JSON(data: data).dictionaryValue.map({(arg0) -> WeatherJSON? in
                if let timestamp = arg0.key.toTimestamp(),
                    let temperature = arg0.value["temperature"]["sol"].float,
                    let rain = arg0.value["pluie"].float,
                    let humidity = arg0.value["humidite"]["2m"].float,
                    let windAverage = arg0.value["vent_moyen"]["10m"].float,
                    let windBurst = arg0.value["vent_rafales"]["10m"].float,
                    let windDirection = arg0.value["vent_direction"]["10m"].float,
                    let snow = arg0.value["risque_neige"].string
                {
                    return WeatherJSON(
                        withTimestamp: timestamp,
                        withDate: arg0.key,
                        withTemperature: temperature,
                        withRain: rain,
                        withHumidity: humidity,
                        withWindAverage: windAverage,
                        withWindBurst: windBurst,
                        withWindDirection: windDirection,
                        withSnow: snow
                    )
                } else {
                    return nil
                }
            })
        } catch  {
            throw WeatherError.parsingError
        }
    }
}

struct WeatherJSON {
    var timestamp: Int
    var date: String
    var temperature: Float
    var rain: Float
    var humidity: Float
    var windAverage: Float
    var windBurst: Float
    var windDirection: Float
    var snow: String
    
    init(
        withTimestamp timestamp: Int,
        withDate date: String,
        withTemperature temperature: Float,
        withRain rain: Float,
        withHumidity humidity: Float,
        withWindAverage windAverage: Float,
        withWindBurst windBurst: Float,
        withWindDirection windDirection: Float,
        withSnow snow: String
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
