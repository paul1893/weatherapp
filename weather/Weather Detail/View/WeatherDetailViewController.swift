import UIKit

class WeatherDetailViewController: UIViewController, WeatherDetailView {
    var id: Int!
    var interactor: WeatherDetailInteractor!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var windAverageLabel: UILabel!
    @IBOutlet weak var windBurstLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.getWeather(id: id)
    }
    
    func showError() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showWeather(with model: WeatherDetailViewModel) {
        temperatureLabel.text = model.temperature
        dateLabel.text = model.date
        windAverageLabel.text = model.windAverage
        windBurstLabel.text = model.windBurst
        windDirectionLabel.text = model.windDirection
        rainLabel.text = model.rain
        humidityLabel.text = model.humidity
    }
}
