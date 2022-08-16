//
//  ViewController+alertController.swift
//  Sunny
//
//  Created by Misha Volkov on 11.08.22.
//

import Foundation
import UIKit

extension ViewController {
    
    // Alert for Search button
    func searchAlertController(withTitle: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: withTitle, message: message, preferredStyle: style)
        
        alertController.addTextField { textField in
            let cities = ["Minsk", "Moscow", "Brest", "New York"]
            textField.placeholder = cities.randomElement()
        }
        
        let searchAction = UIAlertAction(title: "Search", style: .default) { action in
            let textField = alertController.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
//                self.networkWeatherManager.fetchCurrentWeather(forCity: "Minsk") // this work, as example
                let city = cityName.split(separator: " ").joined(separator: "%20") // change space for googleSearch
                completionHandler(city)
            }
        }
        let canselAction = UIAlertAction(title: "Cansel", style: .cancel, handler: nil)
        
        alertController.addAction(searchAction)
        alertController.addAction(canselAction)
        present(alertController, animated: true)
    }
    
}
