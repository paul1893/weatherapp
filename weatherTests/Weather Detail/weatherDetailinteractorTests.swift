import XCTest
@testable import weather

class weatherDetailInteractorTests: XCTestCase {
    
    class MockLocalRepository : LocalWeatherRepositoryImpl {
        var savedList : [Weather]? = nil
        var deleteWeatherListCalled: Bool = false
        var getSavedWeatherListCalled: Bool = false
        
        override func deleteWeatherList() {
            deleteWeatherListCalled = true
        }
        
        override func getSavedWeatherList() -> [Weather] {
            getSavedWeatherListCalled = true
            return [Weather(timestamp: 1, date: "2019-07-20 19:00:00", temperature: 1.0, rain: 0, humidity: 0, windAverage: 0, windBurst: 0, windDirection: 0, snow: false)]
        }
        
        override func saveWeatherList(list weatherList: [Weather]) {
            self.savedList = weatherList
        }
    }
    
    class MockPresenter : WeatherDetailPresenter {
        var error: Bool = false
        var weather: Weather? = nil
        
        func presentError() {
            error = true
        }
        
        func presentWeather(with weather: Weather) {
            self.weather = weather
        }
    }
    
    
    func testGetWeather_WhenDataNotFound() {
        // GIVEN
        let mockLocalRepository = MockLocalRepository()
        let mockPresenter = MockPresenter()
        
        // WHEN
        let interactor = WeatherDetailInteractor(
            localRepository: mockLocalRepository,
            presenter: mockPresenter,
            executor: MockExecutor()
        )
        interactor.getWeather(id: 0)
        
        // THEN
        XCTAssertTrue(mockPresenter.error)
        XCTAssertEqual(mockPresenter.weather, nil)
    }
    
    func testGetWeather() {
        // GIVEN
        let mockLocalRepository = MockLocalRepository()
        let mockPresenter = MockPresenter()
        
        // WHEN
        let interactor = WeatherDetailInteractor(
            localRepository: mockLocalRepository,
            presenter: mockPresenter,
            executor: MockExecutor()
        )
        interactor.getWeather(id: 1)
        
        // THEN
        XCTAssertFalse(mockPresenter.error)
        XCTAssertEqual(mockPresenter.weather, Weather(timestamp: 1, date: "2019-07-20 19:00:00", temperature: 1.0, rain: 0, humidity: 0, windAverage: 0, windBurst: 0, windDirection: 0, snow: false))
    }
}
