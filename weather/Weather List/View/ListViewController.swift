import UIKit
import CoreLocation

class ListViewController: UIViewController, WeatherListView {
    
    @IBOutlet weak var heightHeaderConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var headerTemperatureLabel: UILabel!
    var interactor:  WeatherInteractor!
    private var weatherListViewModel = WeatherListViewModel(header: WeatherHeaderViewModel(temperature: ""), list: [])
    private let locationManager = CLLocationManager()
    private let heightHeaderMax: CGFloat = 250
    private let heightHeaderMin: CGFloat = 44 + UIApplication.shared.statusBarFrame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightHeaderConstraint.constant = heightHeaderMax
        tableView.contentInset = UIEdgeInsets(top: heightHeaderMax, left: 0, bottom: 0, right: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        locationManager.delegate = self
        
        interactor.loadLocalWeatherList()
        checkLocationPermission()
    }
    
    func showError(message: String) {
        errorView.isHidden = false
        errorLabel.text = message
    }
    
    func showWeather(with model: WeatherListViewModel) {
        errorView.isHidden = true
        loaderView.isHidden = true
        headerTemperatureLabel.text = model.header.temperature
        self.weatherListViewModel = model
        tableView.reloadData()
    }
    
    func showEmptyWeather() {
        loaderView.isHidden = false
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        loaderView.isHidden = false
        errorView.isHidden = true
        checkLocationPermission()
    }
}

extension ListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = weatherListViewModel.list[indexPath.row]
        interactor.selectRow(withId: model.timestamp)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y  < 0 {
            let newHeight = max(abs(scrollView.contentOffset.y), heightHeaderMin)
            let progression = (newHeight - heightHeaderMin) / (heightHeaderMax - heightHeaderMin)
            errorView.alpha = progression
            refreshButton.alpha = progression
            heightHeaderConstraint.constant = newHeight
        } else {
            heightHeaderConstraint.constant = heightHeaderMin
        }
    }
}

extension ListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherListViewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") else {
            fatalError("The dequeued cell is not an instance of UITableViewCell.")
        }

        let model = weatherListViewModel.list[indexPath.row]
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
        default:
            fatalError()
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

