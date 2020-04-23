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
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        checkIfLocationServicesAllowed()
        
        if defaults.string(forKey: "cityName") != nil {
            guard let temperatureRange = defaults.string(forKey: "temperatureRange"),
                let weatherIcon = defaults.string(forKey: "weatherIcon"),
                let currentTemperature = defaults.string(forKey: "currentTemperature") else { return }
            
            let cityName = defaults.string(forKey: "cityName")!
            
            DispatchQueue.main.async {
                self.locationNameLabel.text = cityName
                self.temperatureRangeLabel.text = temperatureRange
                self.iconImageView.image = WeatherObject.getWeatherIcon(with: weatherIcon)
                self.currentTempLabel.text = currentTemperature
            }
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func checkIfLocationServicesAllowed() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                // Location Access Allowed
                locationManager.requestLocation()
            default:
                // Location Access Denied / Other
                locationManager.requestWhenInUseAuthorization()
            }
        }
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
            guard let newWeatherObject = newWeatherObject else { return }
            
            self.city?.weatherObject = newWeatherObject
            
            self.defaults.set("\(newWeatherObject.dailyTempHigh)° / \(newWeatherObject.dailyTempLow)°", forKey: "temperatureRange")
            self.defaults.set(newWeatherObject.icon, forKey: "weatherIcon")
            self.defaults.set("\(newWeatherObject.currentTemp)°", forKey: "currentTemperature")
            
            if let city = self.city {
                self.updateUI(with: city)
            }
        }
    }
}



extension TodayViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Get current location
        if let location = locations.last {
            // Get city name
            WeatherManager.getCityName(from: location) { (placemarks) in
                
                if let cityName = placemarks?.locality {

                    self.city = KDTLocationObject(cityName: cityName, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

                    self.getWeather(with: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    
                    self.defaults.set(cityName, forKey: "cityName")
                    self.defaults.set(location.coordinate.latitude, forKey: "latitude")
                    self.defaults.set(location.coordinate.longitude, forKey: "longitude")
                }
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\nThere was an error in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
    }
}
