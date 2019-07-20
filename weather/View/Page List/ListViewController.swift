import UIKit
import CoreLocation

class ListViewController: UIViewController, WeatherListView {
    
    @IBOutlet weak var tableView: UITableView!
    private var modelList = [WeatherViewModel]()
    private let locationManager = CLLocationManager()
    private lazy var interactor = WeatherInteractor(
        repository: WeatherRepositoryImpl(with: CallerImpl(), with: WeatherParser()),
        localRepository: LocalWeatherRepositoryImpl(),
        presenter: WeatherPresenterImpl(view: self)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        locationManager.delegate = self
        
        checkLocationPermission()
    }
    
    func showError(message: String) {
        
    }
    
    func showWeather(with modelList: [WeatherViewModel]) {
        self.modelList = modelList
        tableView.reloadData()
    }
}

extension ListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") else {
            fatalError("The dequeued cell is not an instance of UITableViewCell.")
        }

        let model = modelList[indexPath.row]
        cell.textLabel?.text = model.date
        return cell
    }
}

extension ListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermission()
    }
    
    func checkLocationPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            showError(message: "You do not authorize the app to have access to yout location to get the weather".localized)
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            interactor.getWeatherList(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        } else {
            showError(message: "Cannot access your location".localized)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showError(message: "Cannot access your location".localized)
    }
}

