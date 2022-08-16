//
//  ViewController.swift
//  Sunny
//
//  Created by Misha Volkov on 11.08.22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLable: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLable: UILabel!
    @IBOutlet weak var cityLable: UILabel!
    
    var networkWeatherManager = NetworkWeatherManager()
    
    lazy var locationManager: CLLocationManager = {
       let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        networkWeatherManager.delegate = self
       
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
    }

    @IBAction func searchAction(_ sender: UIButton) {
        searchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            self.networkWeatherManager.fetchCurrentWeather(forRequest: .cityName(city: city)) { [weak self] currentWeather in
                guard let self = self else { return }
                self.updateInterfaceWith(weather: currentWeather)
            }
        }
    }
    
    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.temperatureLable.text = weather.temperatureString
            self.feelsLikeTemperatureLable.text = weather.feelsLikeTemperatureString
            self.cityLable.text = weather.cityName
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
    
}

//extension ViewController: NetworkWeatherManagerDelegate {
//    func updateInterface(_: NetworkWeatherManager, with currentWeather: CurrentWeather) {
//        print(currentWeather.cityName)
//        DispatchQueue.main.async {
//            self.temperatureLable.text = currentWeather.temperatureString
//        }
//
//    }
//}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(forRequest: .coordinate(latitude: latitude, longitude: longitude)) { currentWeather in
            self.updateInterfaceWith(weather: currentWeather)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
