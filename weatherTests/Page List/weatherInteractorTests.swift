import XCTest
@testable import weather

class weatherPresenterTests: XCTestCase {
    
    class MockRepository : WeatherRepository {
        private let error : WeatherError?
        
        init(error: WeatherError? = nil) {
            self.error = error
        }
        
        func getWeather() throws -> [Weather] {
            if let error = error {
                throw error
            }
            return [Weather(temperature: 1.0)]
        }
    }
    
    class MockPresenter : WeatherPresenter {
        var error: Bool = false
        var weatherList: [Weather] = []
        
        func presentError() {
            error = true
        }
        
        func presentWeather(with weatherList: [Weather]) {
            self.weatherList = weatherList
        }
    }
    
    
    func testGetWeatherList_WhenRepositoryThrowError() {
        // GIVEN
        let mockRepository = MockRepository(error: WeatherError.serverError)
        let mockPresenter = MockPresenter()
        
        // WHEN
        let interactor = WeatherInteractor(repository: mockRepository, presenter: mockPresenter, executor: MockExecutor())
        interactor.getWeatherList()
        
        // THEN
        XCTAssertTrue(mockPresenter.error)
        XCTAssertEqual(mockPresenter.weatherList.count, 0)
    }
    
    func testGetWeatherList() {
        // GIVEN
        let mockRepository = MockRepository()
        let mockPresenter = MockPresenter()
        
        // WHEN
        let interactor = WeatherInteractor(repository: mockRepository, presenter: mockPresenter, executor: MockExecutor())
        interactor.getWeatherList()
        
        // THEN
        XCTAssertFalse(mockPresenter.error)
        XCTAssertEqual(mockPresenter.weatherList.count, 1)
        XCTAssertEqual(mockPresenter.weatherList[0], Weather(temperature: 1.0))
    }
}
