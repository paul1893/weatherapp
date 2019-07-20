import Foundation
import UIKit
import CoreData

protocol LocalWeatherRepository {
    func deleteWeatherList()
    func getSavedWeatherList() -> [Weather]
    func saveWeatherList(weatherList: [Weather])
}

class LocalWeatherRepositoryImpl {
    private let tableName = "WeatherDb"
    private let context: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func deleteWeatherList() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            // Do nothing
        }
    }
    
    func getSavedWeatherList() -> [Weather] {
        var weatherList = [Weather]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                weatherList.append(Weather(temperature: data.value(forKey: "temperature") as! Float))
            }
        } catch {
            // Do nothing
        }
        return weatherList
    }
    
    func saveWeatherList(weatherList: [Weather]) {
        weatherList.forEach { (weather) in
            if let entity = NSEntityDescription.entity(forEntityName: tableName, in: context) {
                let newWeather = NSManagedObject(entity: entity, insertInto: context)
                newWeather.setValue(weather.temperature, forKey: "temperature")
                
                do {
                    try context.save()
                } catch {
                    // Do nothing
                }
            }
        }
    }
}
