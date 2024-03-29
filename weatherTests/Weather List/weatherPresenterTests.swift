import XCTest
@testable import weather

class weatherPresenterTests: XCTestCase {

    class MockView : WeatherListView {
        var message : String? = nil
        var model : WeatherListViewModel? = nil
        var showEmptyWeatherCalled : Bool = false
        
        func showError(message: String) {
            self.message = message
        }
        
        func showWeather(with model: WeatherListViewModel) {
            self.model = model
        }
        
        func showEmptyWeather() {
            self.showEmptyWeatherCalled = true
        }
    }
    
    func testPresentError() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherPresenterImpl(view: mockView, executor: MockExecutor())
        presenter.presentError()
        
        // THEN
        XCTAssertNotNil(mockView.message)
        XCTAssertEqual(mockView.message!, "Something went wrong cannot get the weather ! Please try again later")
        XCTAssertEqual(mockView.model, nil)
    }
    
    func testPresentWeatherList() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherPresenterImpl(view: mockView, executor: MockExecutor())
        presenter.presentWeather(with: [Weather(timestamp: "1", date: "2019-07-20 14:00:00", temperature: 273.15, rain: 0, humidity: 0, windAverage: 0, windBurst: 0, windDirection: 0, snow: false)])
        
        // THEN
        XCTAssertNil(mockView.message)
        XCTAssertEqual(mockView.model,
                       WeatherListViewModel(
                        header: WeatherHeaderViewModel(temperature: "0 °C", date: "2019-07-20 14:00:00"),
                        list: [WeatherViewModel(timestamp: "1", date: "2019-07-20 14:00:00")]
        ))
    }
    
    func testPresentOutdatedData() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherPresenterImpl(view: mockView, executor: MockExecutor())
        presenter.presentOutdatedData()
        
        // THEN
        XCTAssertNotNil(mockView.message)
        XCTAssertEqual(mockView.message!, "This is offline data, they must be outdated")
        XCTAssertEqual(mockView.model, nil)
    }
    
    func testPresentEmptyWeather() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherPresenterImpl(view: mockView, executor: MockExecutor())
        presenter.presentWeather(with: [])
        
        // THEN
        XCTAssertNil(mockView.message)
        XCTAssertEqual(mockView.model, nil)
        XCTAssertTrue(mockView.showEmptyWeatherCalled)
    }
}
