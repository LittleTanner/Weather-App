//
//  TodayViewController.swift
//  TodayWeatherExtension
//
//  Created by Kevin Tanner on 4/23/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var temperatureRangeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    var city: KDTLocationObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        WeatherManager.shared.loadFromPersistentStore()
        
        city = WeatherManager.shared.cities[0]
        print(WeatherManager.shared.cities[0].cityName)

        if let city = city {
            
            WeatherUserDefaults.shared.defaults.set(city.cityName, forKey: "cityName")
            WeatherUserDefaults.shared.defaults.set(city.latitude, forKey: "latitude")
            WeatherUserDefaults.shared.defaults.set(city.longitude, forKey: "longitude")
        }
//        let cityName = WeatherUserDefaults.shared.defaults.string(forKey: "cityName") ?? "Unknkown"
//        let latitude = WeatherUserDefaults.shared.defaults.double(forKey: "latitude") ?? 37.3230
//        let longitude = WeatherUserDefaults.shared.defaults.double(forKey: "longitude") ?? -122.0322
//        city = KDTLocationObject(cityName: cityName, latitude: latitude, longitude: longitude)
//            updateUI(with: KDTLocationObject(cityName: cityName, latitude: latitude, longitude: longitude))
        
//        if let city = WeatherManager.shared.cities.first {
//            updateUI(with: city)
//        }
        
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        guard let city = city else { completionHandler(NCUpdateResult.failed); return }
        
        getWeather(with: city.latitude, longitude: city.longitude)
        
        DispatchQueue.main.async {
            self.locationNameLabel.text = city.cityName
        }
        
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func updateUI(with city: KDTLocationObject) {
        
        guard let iconString = city.weatherObject?.icon,
            let dailyTempHigh = city.weatherObject?.dailyTempHigh,
            let dailyTempLow = city.weatherObject?.dailyTempLow,
            let currentTemp = city.weatherObject?.currentTemp else { return }
        
        DispatchQueue.main.async {
            self.locationNameLabel.text = city.cityName
            self.temperatureRangeLabel.text = "\(dailyTempHigh)° / \(dailyTempLow)°"
            self.iconImageView.image = WeatherObject.getWeatherIcon(with: iconString)
            self.currentTempLabel.text = "\(currentTemp)°"
        }
    }
    
    func getWeather(with latitude: Double, longitude: Double) {
        
        WeatherNetworkManager().getWeather(latitude: latitude, longitude: longitude) { (newWeatherObject) in
            guard let newWeatherObject = newWeatherObject, let city = self.city else { return }
            
            WeatherManager.shared.updateWeatherObject(with: newWeatherObject, location: city)
            
            DispatchQueue.main.async {
                self.temperatureRangeLabel.text = "\(newWeatherObject.dailyTempHigh)° / \(newWeatherObject.dailyTempLow)°"
                self.iconImageView.image = WeatherObject.getWeatherIcon(with: newWeatherObject.icon)
                self.currentTempLabel.text = "\(newWeatherObject.currentTemp)°"
            }
        }
    }
}
