import Foundation

enum WeatherError: Error {
    case serverError
    case parsingError
    case wrongUrl
}

class WeatherRepository {
    private let caller: Caller
    private let parser: Parser
    
    init(with caller: Caller, with parser: Parser) {
        self.caller = caller
        self.parser = parser
    }
    
    private let apiUrl = "https://www.infoclimat.fr/public-api/gfs/json?_ll=48.85341,2.3488&_auth=AhgHEFMtU3FVeAA3BHJWfwRsBzJbLQYhAn5RMlg9A35UPwBhVjYBZwRqB3oOIQI0VnsDYAoxCTlUP1AoCHpRMAJoB2tTOFM0VToAZQQrVn0EKgdmW3sGIQJgUTBYMAN%2BVDUAZlYwAX0EbAdiDiACNVZnA3wKKgkwVDJQMQhmUTcCZQdmUzFTMlU5AH0EK1ZnBGMHZFtlBm0CNFE0WGEDM1Q%2FAGNWZAFkBGIHew42AjVWbQNnCjQJMFQzUD4IelEtAhgHEFMtU3FVeAA3BHJWfwRiBzlbMA%3D%3D&_c=ee18549d89365b7f4abe3be86cd2b67b"
    
    func getWeather() throws -> [Weather] {
        
        if let url = URL(string: apiUrl) {
            let (receivedData, error) = caller.get(with: url)
            guard error == nil else { throw WeatherError.serverError }
            guard let data = receivedData else { throw WeatherError.serverError }
            
            let weatherList = try parser.parse(data)
                .compactMap({$0})
                .sorted { (first, second) -> Bool in
                    first.date > second.date
            }
            return weatherList.map({ (weatherJSON) -> Weather in
                Weather(temperature: weatherJSON.temperature)
            })
        } else {
            throw WeatherError.wrongUrl
        }
    }
}

extension String {
    func toTimestamp() -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let result = dateFormatter.date(from: self)
        guard let date = result else { return nil }
        return Int(date.timeIntervalSince1970)
    }
}
