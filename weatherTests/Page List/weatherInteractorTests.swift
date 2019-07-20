import XCTest
@testable import weather

class weatherInteractorTests: XCTestCase {
    
    class MockRepository : WeatherRepository {
        private let error : WeatherError?
        
        init(error: WeatherError? = nil) {
            self.error = error
        }
        
        func getWeather(withLatitude latitude: Double, withLongitude longitude: Double) throws -> [Weather] {
            if let error = error {
                throw error
            }
            return [Weather(timestamp: 1, date: "2019-07-20 19:00:00", temperature: 1.0, rain: 0, humidity: 0, windAverage: 0, windBurst: 0, windDirection: 0, snow: false)]
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
        interactor.getWeatherList(latitude: 48, longitude: 2)
        
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
        interactor.getWeatherList(latitude: 48, longitude: 2)
        
        // THEN
        XCTAssertFalse(mockPresenter.error)
        XCTAssertEqual(mockPresenter.weatherList.count, 1)
        XCTAssertEqual(mockPresenter.weatherList[0], Weather(timestamp: 1, date: "2019-07-20 19:00:00", temperature: 1.0, rain: 0, humidity: 0, windAverage: 0, windBurst: 0, windDirection: 0, snow: false))
    }
}
