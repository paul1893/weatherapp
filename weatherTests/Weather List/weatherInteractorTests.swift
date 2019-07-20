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
            return [Weather(timestamp: "1", date: "2019-07-20 19:00:00", temperature: 1.0, rain: 0, humidity: 0, windAverage: 0, windBurst: 0, windDirection: 0, snow: false)]
        }
    }
    
    class MockLocalRepository : LocalWeatherRepository {
        var savedList : [Weather]? = nil
        var deleteWeatherListCalled: Bool = false
        var getSavedWeatherListCalled: Bool = false
        
        func deleteWeatherList() {
            deleteWeatherListCalled = true
        }
        
        func getSavedWeatherList() -> [Weather] {
            getSavedWeatherListCalled = true
            return [Weather(timestamp: "1", date: "2019-07-20 19:00:00", temperature: 1.0, rain: 0, humidity: 0, windAverage: 0, windBurst: 0, windDirection: 0, snow: false)]
        }
        
        func saveWeatherList(list weatherList: [Weather]) {
            self.savedList = weatherList
        }
    }
    
    class MockDeviceManager : DeviceManager {
        private let isOnlineProperty: Bool
        
        init(isOnlineProperty: Bool = true) {
            self.isOnlineProperty = isOnlineProperty
        }
        
        func isOnline() -> Bool {
            return isOnlineProperty
        }
    }
    
    class MockAppRouter: Router {
        var currentLink: Link? = nil
        func go(to link: Link) {
            self.currentLink = link
        }
    }
    
    class MockPresenter : WeatherPresenter {
        var presentErrorCalled: Bool = false
        var presentOutdatedDataCalled: Bool = false
        var weatherList: [Weather] = []
        
        func presentError() {
            presentErrorCalled = true
        }
        
        func presentOutdatedData() {
            presentOutdatedDataCalled = true
        }
        
        func presentWeather(with weatherList: [Weather]) {
            self.weatherList = weatherList
        }
    }
    
    
    func testGetWeatherList_WhenRepositoryThrowError() {
        // GIVEN
        let mockRepository = MockRepository(error: WeatherError.serverError)
        let mockLocalRepository = MockLocalRepository()
        let mockDeviceManager = MockDeviceManager()
        let mockRouter = MockAppRouter()
        let mockPresenter = MockPresenter()
        
        // WHEN
        let interactor = WeatherInteractor(
            repository: mockRepository,
            localRepository: mockLocalRepository,
            presenter: mockPresenter,
            deviceManager: mockDeviceManager,
            router: mockRouter,
            executor: MockExecutor()
        )
        interactor.getWeatherList(latitude: 48, longitude: 2)
        
        // THEN
        XCTAssertTrue(mockPresenter.presentErrorCalled)
        XCTAssertEqual(mockPresenter.weatherList.count, 0)
    }
    
    func testGetWeatherList() {
        // GIVEN
        let mockRepository = MockRepository()
        let mockLocalRepository = MockLocalRepository()
        let mockDeviceManager = MockDeviceManager()
        let mockRouter = MockAppRouter()
        let mockPresenter = MockPresenter()
        
        // WHEN
        let interactor = WeatherInteractor(
            repository: mockRepository,
            localRepository: mockLocalRepository,
            presenter: mockPresenter,
            deviceManager: mockDeviceManager,
            router: mockRouter,
            executor: MockExecutor()
        )
        interactor.getWeatherList(latitude: 48, longitude: 2)
        
        // THEN
        XCTAssertFalse(mockPresenter.presentErrorCalled)
        XCTAssertTrue(mockLocalRepository.deleteWeatherListCalled)
        XCTAssertEqual(mockLocalRepository.savedList!, mockPresenter.weatherList)
        XCTAssertEqual(mockPresenter.weatherList.count, 1)
        XCTAssertEqual(mockPresenter.weatherList[0], Weather(timestamp: "1", date: "2019-07-20 19:00:00", temperature: 1.0, rain: 0, humidity: 0, windAverage: 0, windBurst: 0, windDirection: 0, snow: false))
    }
    
    func testselectRow() {
        // GIVEN
        let mockRepository = MockRepository()
        let mockLocalRepository = MockLocalRepository()
        let mockDeviceManager = MockDeviceManager()
        let mockRouter = MockAppRouter()
        let mockPresenter = MockPresenter()
        
        // WHEN
        let interactor = WeatherInteractor(
            repository: mockRepository,
            localRepository: mockLocalRepository,
            presenter: mockPresenter,
            deviceManager: mockDeviceManager,
            router: mockRouter,
            executor: MockExecutor()
        )
        interactor.selectRow(withId: "1")
        
        // THEN
        XCTAssertNotNil(mockRouter.currentLink)
        XCTAssertEqual(mockRouter.currentLink!, Link.weatherDetail(id: "1"))
    }
    
    func testGetWeatherList_WhenOffline() {
        // GIVEN
        let weatherList = [Weather(timestamp: "1", date: "2019-07-20 19:00:00", temperature: 1.0, rain: 0, humidity: 0, windAverage: 0, windBurst: 0, windDirection: 0, snow: false)]
        let mockRepository = MockRepository()
        let mockDeviceManager = MockDeviceManager(isOnlineProperty: false)
        let mockRouter = MockAppRouter()
        let mockPresenter = MockPresenter()
        let mockLocalRepository = MockLocalRepository()
        mockLocalRepository.savedList = weatherList
        
        
        // WHEN
        let interactor = WeatherInteractor(
            repository: mockRepository,
            localRepository: mockLocalRepository,
            presenter: mockPresenter,
            deviceManager: mockDeviceManager,
            router: mockRouter,
            executor: MockExecutor()
        )
        interactor.getWeatherList(latitude: 48, longitude: 2)
        
        // THEN
        XCTAssertFalse(mockPresenter.presentErrorCalled)
        XCTAssertFalse(mockLocalRepository.deleteWeatherListCalled)
        XCTAssertTrue(mockPresenter.presentOutdatedDataCalled)
        XCTAssertEqual(mockPresenter.weatherList, weatherList)
    }
    
    func testLoadLocalWeatherList() {
        // GIVEN
        let weatherList = [Weather(timestamp: "1", date: "2019-07-20 19:00:00", temperature: 1.0, rain: 0, humidity: 0, windAverage: 0, windBurst: 0, windDirection: 0, snow: false)]
        let mockRepository = MockRepository()
        let mockDeviceManager = MockDeviceManager(isOnlineProperty: false)
        let mockRouter = MockAppRouter()
        let mockPresenter = MockPresenter()
        let mockLocalRepository = MockLocalRepository()
        mockLocalRepository.savedList = weatherList
        
        
        // WHEN
        let interactor = WeatherInteractor(
            repository: mockRepository,
            localRepository: mockLocalRepository,
            presenter: mockPresenter,
            deviceManager: mockDeviceManager,
            router: mockRouter,
            executor: MockExecutor()
        )
        interactor.loadLocalWeatherList()
        
        // THEN
        XCTAssertFalse(mockPresenter.presentErrorCalled)
        XCTAssertEqual(mockPresenter.weatherList, weatherList)
        XCTAssertFalse(mockPresenter.presentOutdatedDataCalled)
    }
}
