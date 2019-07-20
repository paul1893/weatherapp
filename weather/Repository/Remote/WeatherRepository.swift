import Foundation

enum WeatherError: Error {
    case serverError
    case parsingError
    case wrongUrl
}

protocol WeatherRepository {
    func getWeather(withLatitude latitude: Double, withLongitude longitude: Double) throws -> [Weather]
}

class WeatherRepositoryImpl : WeatherRepository {
    private let caller: Caller
    private let parser: Parser
    
    init(with caller: Caller, with parser: Parser) {
        self.caller = caller
        self.parser = parser
    }
    
    private func apiUrl(_ latitude: Double, _ longitude: Double) -> String  {
        return "https://www.infoclimat.fr/public-api/gfs/json?_ll=\(latitude),\(longitude)&_auth=AhgHEFMtU3FVeAA3BHJWfwRsBzJbLQYhAn5RMlg9A35UPwBhVjYBZwRqB3oOIQI0VnsDYAoxCTlUP1AoCHpRMAJoB2tTOFM0VToAZQQrVn0EKgdmW3sGIQJgUTBYMAN%2BVDUAZlYwAX0EbAdiDiACNVZnA3wKKgkwVDJQMQhmUTcCZQdmUzFTMlU5AH0EK1ZnBGMHZFtlBm0CNFE0WGEDM1Q%2FAGNWZAFkBGIHew42AjVWbQNnCjQJMFQzUD4IelEtAhgHEFMtU3FVeAA3BHJWfwRiBzlbMA%3D%3D&_c=ee18549d89365b7f4abe3be86cd2b67b"
    }
    
    func getWeather(withLatitude latitude: Double, withLongitude longitude: Double) throws -> [Weather] {
        if let url = URL(string: apiUrl(latitude, longitude)) {
            let (receivedData, error) = caller.get(with: url)
            guard error == nil else { throw WeatherError.serverError }
            guard let data = receivedData else { throw WeatherError.serverError }
            
            let weatherList = try parser.parse(data)
                .compactMap({$0})
                .sorted { (first, second) -> Bool in
                    first.timestamp < second.timestamp
            }
            return weatherList.map({ (weatherJSON) -> Weather in
                Weather(
                    timestamp: weatherJSON.timestamp,
                    date: weatherJSON.date,
                    temperature: weatherJSON.temperature,
                    rain: weatherJSON.rain,
                    humidity: weatherJSON.humidity,
                    windAverage: weatherJSON.windAverage,
                    windBurst: weatherJSON.windBurst,
                    windDirection: weatherJSON.windDirection,
                    snow: weatherJSON.snow == "oui" ? true : false
                )
            })
        } else {
            throw WeatherError.wrongUrl
        }
    }
}

extension String {
    func toTimestamp() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let result = dateFormatter.date(from: self)
        guard let date = result else { return nil }
        return "\(Int(date.timeIntervalSince1970))"
    }
}
