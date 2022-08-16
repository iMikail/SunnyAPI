//
//  NetworkWeatherManager.swift
//  Sunny
//
//  Created by Misha Volkov on 11.08.22.
//

import Foundation
import CoreLocation
// передача currentWeather через делегирование

//protocol NetworkWeatherManagerDelegate: AnyObject {
//    func updateInterface(_: NetworkWeatherManager, with currentWeather: CurrentWeather)
//}

class NetworkWeatherManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
//    weak var delegate: NetworkWeatherManagerDelegate?
    
    // запрос на сервер
    func fetchCurrentWeather(forRequest request: RequestType, completionHandler: @escaping (CurrentWeather) -> Void) {
        var urlString = ""
        switch request {
            case .cityName(let city):
                urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(Constants.apiKey)&units=metric"
            case .coordinate(let latitude, let longitude):
                urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(Constants.apiKey)&units=metric"
        }
        performRequest(withURLString: urlString, completionHandler: completionHandler)
    }
    
    private func performRequest(withURLString urlString: String, completionHandler: @escaping (CurrentWeather) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
//                    self.delegate?.updateInterface(self, with: currentWeather)
                    completionHandler(currentWeather)
                }
            }
        }
        task.resume()
    }
    
   private func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
           let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
