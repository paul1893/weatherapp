import XCTest
@testable import weather

class weatherDetailPresenterTests: XCTestCase {
    
    class MockView : WeatherDetailView {
        var showErrorCalled : Bool = false
        var model : WeatherDetailViewModel? = nil
        
        func showError() {
            self.showErrorCalled = true
        }
        func showWeather(with model: WeatherDetailViewModel) {
            self.model = model
        }
    }
    
    func testPresentError() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherDetailPresenterImpl(view: mockView, executor: MockExecutor())
        presenter.presentError()
        
        // THEN
        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(mockView.model, nil)
    }
    
    func testPresentWeather_WhenEastDirection() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherDetailPresenterImpl(view: mockView, executor: MockExecutor())
        presenter.presentWeather(with:
            Weather(timestamp: "1",
                    date: "2019-07-20 14:00:00",
                    temperature: 273.15,
                    rain: 0,
                    humidity: 0,
                    windAverage: 0,
                    windBurst: 0,
                    windDirection: 0,
                    snow: false)
        )
        
        // THEN
        XCTAssertFalse(mockView.showErrorCalled)
        XCTAssertEqual(mockView.model, WeatherDetailViewModel(
            date: "2019-07-20 14:00:00",
            temperature: "0 °C",
            rain: "0.0 mm",
            humidity: "0.0 %",
            windAverage: "0.0 km/h",
            windBurst: "0.0 km/h",
            windDirection: "East"
        ))
    }
    
    func testPresentWeather_WhenNorthEastDirection() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherDetailPresenterImpl(view: mockView, executor: MockExecutor())
        presenter.presentWeather(with:
            Weather(timestamp: "1",
                    date: "2019-07-20 14:00:00",
                    temperature: 273.15,
                    rain: 0,
                    humidity: 0,
                    windAverage: 0,
                    windBurst: 0,
                    windDirection: 30,
                    snow: false)
        )
        
        // THEN
        XCTAssertFalse(mockView.showErrorCalled)
        XCTAssertEqual(mockView.model, WeatherDetailViewModel(
            date: "2019-07-20 14:00:00",
            temperature: "0 °C",
            rain: "0.0 mm",
            humidity: "0.0 %",
            windAverage: "0.0 km/h",
            windBurst: "0.0 km/h",
            windDirection: "North-East"
        ))
    }
    
    func testPresentWeather_WhenNorthDirection() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherDetailPresenterImpl(view: mockView, executor: MockExecutor())
        presenter.presentWeather(with:
            Weather(timestamp: "1",
                    date: "2019-07-20 14:00:00",
                    temperature: 273.15,
                    rain: 0,
                    humidity: 0,
                    windAverage: 0,
                    windBurst: 0,
                    windDirection: 90,
                    snow: false)
        )
        
        // THEN
        XCTAssertFalse(mockView.showErrorCalled)
        XCTAssertEqual(mockView.model, WeatherDetailViewModel(
            date: "2019-07-20 14:00:00",
            temperature: "0 °C",
            rain: "0.0 mm",
            humidity: "0.0 %",
            windAverage: "0.0 km/h",
            windBurst: "0.0 km/h",
            windDirection: "North"
        ))
    }
    
    func testPresentWeather_WhenNorthWestDirection() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherDetailPresenterImpl(view: mockView, executor: MockExecutor())
        presenter.presentWeather(with:
            Weather(timestamp: "1",
                    date: "2019-07-20 14:00:00",
                    temperature: 273.15,
                    rain: 0,
                    humidity: 0,
                    windAverage: 0,
                    windBurst: 0,
                    windDirection: 120,
                    snow: false)
        )
        
        // THEN
        XCTAssertFalse(mockView.showErrorCalled)
        XCTAssertEqual(mockView.model, WeatherDetailViewModel(
            date: "2019-07-20 14:00:00",
            temperature: "0 °C",
            rain: "0.0 mm",
            humidity: "0.0 %",
            windAverage: "0.0 km/h",
            windBurst: "0.0 km/h",
            windDirection: "North-West"
        ))
    }
    
    func testPresentWeather_WhenWestDirection() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherDetailPresenterImpl(view: mockView, executor: MockExecutor())
        presenter.presentWeather(with:
            Weather(timestamp: "1",
                    date: "2019-07-20 14:00:00",
                    temperature: 273.15,
                    rain: 0,
                    humidity: 0,
                    windAverage: 0,
                    windBurst: 0,
                    windDirection: 180,
                    snow: false)
        )
        
        // THEN
        XCTAssertFalse(mockView.showErrorCalled)
        XCTAssertEqual(mockView.model, WeatherDetailViewModel(
            date: "2019-07-20 14:00:00",
            temperature: "0 °C",
            rain: "0.0 mm",
            humidity: "0.0 %",
            windAverage: "0.0 km/h",
            windBurst: "0.0 km/h",
            windDirection: "West"
        ))
    }
    
    func testPresentWeather_WhenSouthWestDirection() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherDetailPresenterImpl(view: mockView, executor: MockExecutor())
        presenter.presentWeather(with:
            Weather(timestamp: "1",
                    date: "2019-07-20 14:00:00",
                    temperature: 273.15,
                    rain: 0,
                    humidity: 0,
                    windAverage: 0,
                    windBurst: 0,
                    windDirection: 220,
                    snow: false)
        )
        
        // THEN
        XCTAssertFalse(mockView.showErrorCalled)
        XCTAssertEqual(mockView.model, WeatherDetailViewModel(
            date: "2019-07-20 14:00:00",
            temperature: "0 °C",
            rain: "0.0 mm",
            humidity: "0.0 %",
            windAverage: "0.0 km/h",
            windBurst: "0.0 km/h",
            windDirection: "South-West"
        ))
    }
    
    func testPresentWeather_WhenSouthDirection() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherDetailPresenterImpl(view: mockView, executor: MockExecutor())
        presenter.presentWeather(with:
            Weather(timestamp: "1",
                    date: "2019-07-20 14:00:00",
                    temperature: 273.15,
                    rain: 0,
                    humidity: 0,
                    windAverage: 0,
                    windBurst: 0,
                    windDirection: 270,
                    snow: false)
        )
        
        // THEN
        XCTAssertFalse(mockView.showErrorCalled)
        XCTAssertEqual(mockView.model, WeatherDetailViewModel(
            date: "2019-07-20 14:00:00",
            temperature: "0 °C",
            rain: "0.0 mm",
            humidity: "0.0 %",
            windAverage: "0.0 km/h",
            windBurst: "0.0 km/h",
            windDirection: "South"
        ))
    }
    
    func testPresentWeather_WhenSouthEastDirection() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherDetailPresenterImpl(view: mockView, executor: MockExecutor())
        presenter.presentWeather(with:
            Weather(timestamp: "1",
                    date: "2019-07-20 14:00:00",
                    temperature: 273.15,
                    rain: 0,
                    humidity: 0,
                    windAverage: 0,
                    windBurst: 0,
                    windDirection: 300,
                    snow: false)
        )
        
        // THEN
        XCTAssertFalse(mockView.showErrorCalled)
        XCTAssertEqual(mockView.model, WeatherDetailViewModel(
            date: "2019-07-20 14:00:00",
            temperature: "0 °C",
            rain: "0.0 mm",
            humidity: "0.0 %",
            windAverage: "0.0 km/h",
            windBurst: "0.0 km/h",
            windDirection: "South-East"
        ))
    }
}
