import XCTest
@testable import weather

class weatherInteractorTests: XCTestCase {

    class MockView : WeatherListView {
        var message : String? = nil
        var model : [WeatherViewModel] = []
        
        func showError(message: String) {
            self.message = message
        }
        func showWeather(with model: [WeatherViewModel]) {
            self.model = model
        }
    }
    
    
    func testPresentError() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherPresenterImpl(view: mockView)
        presenter.presentError()
        
        // THEN
        XCTAssertNotNil(mockView.message)
        XCTAssertEqual(mockView.message!, "Something went wrong cannot get the weather ! Please try again later")
        XCTAssertEqual(mockView.model.count, 0)
    }
    
    func testPresentWeatherList() {
        // GIVEN
        let mockView = MockView()
        
        // WHEN
        let presenter = WeatherPresenterImpl(view: mockView)
        presenter.presentWeather(with: [Weather(temperature: 273.15)])
        
        // THEN
        XCTAssertNil(mockView.message)
        XCTAssertEqual(mockView.model.count, 1)
        XCTAssertEqual(mockView.model[0], WeatherViewModel(temperature: "0.0 °C"))
    }
}
