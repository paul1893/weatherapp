import Foundation
import UIKit
import CoreData

protocol LocalWeatherRepository {
    func deleteWeatherList()
    func getSavedWeatherList() -> [Weather]
    func saveWeatherList(list weatherList: [Weather])
}

class LocalWeatherRepositoryImpl: LocalWeatherRepository {
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
                weatherList.append(
                    Weather(
                        timestamp: data.value(forKey: "timestamp") as! String,
                        date: data.value(forKey: "date") as! String,
                        temperature: data.value(forKey: "temperature") as! Float,
                        rain: data.value(forKey: "rain") as! Float,
                        humidity: data.value(forKey: "humidity") as! Float,
                        windAverage: data.value(forKey: "windAverage") as! Float,
                        windBurst: data.value(forKey: "windBurst") as! Float,
                        windDirection: data.value(forKey: "windDirection") as! Float,
                        snow: data.value(forKey: "snow") as! Bool
                    )
                )
            }
        } catch {
            // Do nothing
        }
        return weatherList
            .compactMap({$0})
            .sorted { (first, second) -> Bool in
                first.timestamp < second.timestamp
        }
    }
    
    func saveWeatherList(list weatherList: [Weather]) {
        weatherList.forEach { (weather) in
            if let entity = NSEntityDescription.entity(forEntityName: tableName, in: context) {
                let newWeather = NSManagedObject(entity: entity, insertInto: context)
                newWeather.setValue(weather.timestamp, forKey: "timestamp")
                newWeather.setValue(weather.date, forKey: "date")
                newWeather.setValue(weather.temperature, forKey: "temperature")
                newWeather.setValue(weather.rain, forKey: "rain")
                newWeather.setValue(weather.humidity, forKey: "humidity")
                newWeather.setValue(weather.windAverage, forKey: "windAverage")
                newWeather.setValue(weather.windBurst, forKey: "windBurst")
                newWeather.setValue(weather.windDirection, forKey: "windDirection")
                newWeather.setValue(weather.snow, forKey: "snow")
            }
            do {
                try context.save()
            } catch {
                // Do nothing
            }
        }
    }
}
