import UIKit

class ListViewController: UIViewController, WeatherListView {
    
    @IBOutlet weak var tableView: UITableView!
    private var modelList = [WeatherViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        let interactor = WeatherInteractor(
            repository: WeatherRepositoryImpl(with: CallerImpl(), with: WeatherParser()),
            presenter: WeatherPresenterImpl(view: self)
        )
        interactor.getWeatherList()
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

