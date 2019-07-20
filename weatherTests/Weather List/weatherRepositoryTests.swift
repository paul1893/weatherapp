import XCTest
@testable import weather

class weatherRepositoryTests: XCTestCase {

    class MockCaller : Caller {
        var data: Data? = Data()
        var error: Error? = nil
        
        func get(with url: URL) -> (Data?, Error?) {
            return (data, error)
        }
    }
    
    class MockParser : Parser {
        private let error: WeatherError?
        
        init(error: WeatherError? = nil) {
            self.error = error
        }
        
        func parse(_ data: Data) throws -> [WeatherJSON?] {
            if let error = error {
                throw error
            }
            return [
                WeatherJSON(withTimestamp: "1", withDate: "2019-07-20 17:00:00", withTemperature: 2.0, withRain: 0, withHumidity: 0, withWindAverage: 0, withWindBurst: 0, withWindDirection: 0, withSnow: "non"),
                nil,
                WeatherJSON(withTimestamp: "0", withDate: "2019-07-20 14:00:00", withTemperature: 1.0, withRain: 0, withHumidity: 0, withWindAverage: 0, withWindBurst: 0, withWindDirection: 0, withSnow: "oui")
            ]
        }
    }
    
    func testGetWeather() {
        // GIVEN
        let mockCaller = MockCaller()
        let mockParser = MockParser()
        
        // WHEN
        let repository = WeatherRepositoryImpl(with: mockCaller, with: mockParser)
        
        do {
            let result = try repository.getWeather(withLatitude: 48, withLongitude: 2)
            
            // THEN
            XCTAssertEqual(result[0], Weather(timestamp: "0", date: "2019-07-20 14:00:00", temperature: 1.0, rain: 0, humidity: 0, windAverage: 0, windBurst: 0, windDirection: 0, snow: true))
            XCTAssertEqual(result[1], Weather(timestamp: "1", date: "2019-07-20 17:00:00", temperature: 2.0, rain: 0, humidity: 0, windAverage: 0, windBurst: 0, windDirection: 0, snow: false))
            XCTAssertEqual(result.count, 2)
        } catch  {
            XCTFail()
        }
    }
    
    func testGetWeather_WhenServerError_BecauseErrorNotNil() {
        // GIVEN
        let mockCaller = MockCaller()
        mockCaller.error = WeatherError.serverError
        let mockParser = MockParser()
        
        // WHEN
        let repository = WeatherRepositoryImpl(with: mockCaller, with: mockParser)
        
        do {
            _ = try repository.getWeather(withLatitude: 48, withLongitude: 2)
            XCTFail()
        } catch {
            // THEN
            XCTAssertTrue(true)
        }
    }
    
    func testGetWeather_WhenServerError_BecauseDataIsNil() {
        // GIVEN
        let mockCaller = MockCaller()
        mockCaller.data = nil
        let mockParser = MockParser()
        
        // WHEN
        let repository = WeatherRepositoryImpl(with: mockCaller, with: mockParser)
        
        do {
            _ = try repository.getWeather(withLatitude: 48, withLongitude: 2)
            XCTFail()
        } catch {
            // THEN
            XCTAssertTrue(true)
        }
    }
    
    func testGetWeather_WhenParserError() {
        // GIVEN
        let mockCaller = MockCaller()
        let mockParser = MockParser(error: WeatherError.parsingError)
        
        // WHEN
        let repository = WeatherRepositoryImpl(with: mockCaller, with: mockParser)
        
        do {
            _ = try repository.getWeather(withLatitude: 48, withLongitude: 2)
            XCTFail()
        } catch {
            // THEN
            XCTAssertTrue(true)
        }
    }
    
    
    func testStringToTimestamp() {
        XCTAssertEqual("2019-07-19 22:30:30".toTimestamp(), "1563568230")
        XCTAssertEqual("2019-07-17 15:33:30".toTimestamp(), "1563370410")
        XCTAssertEqual("2019-07-17".toTimestamp(), nil)
        XCTAssertEqual("15:33:30".toTimestamp(), nil)
        XCTAssertEqual("Hello".toTimestamp(), nil)
    }
}
