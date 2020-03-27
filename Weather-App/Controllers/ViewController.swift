//
//  ViewController.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/25/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var chanceOfRainLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var dailySummaryLabel: UILabel!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    var weatherObject: WeatherObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        weatherManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

// MARK: - Weather Manager Delegate

extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherData) {
        
        guard let currentWeather = weather.currently,
              let dailyWeather = weather.daily,
              let dailySummary = dailyWeather.data.first?.summary else { return }
        
        let currentTemp = Int(currentWeather.temperature)
        let currentSummary = currentWeather.summary
        let chanceOfRainAsDouble = currentWeather.precipProbability * 100.0
        let chanceOfRain = Int(chanceOfRainAsDouble)
        let humidityAsDouble = currentWeather.humidity * 100.0
        let humidity = Int(humidityAsDouble)
        let visibility = currentWeather.visibility
        
        weatherObject = WeatherObject(currentTemp: currentTemp, currentSummary: currentSummary, chanceOfRain: chanceOfRain, humidity: humidity, visibility: visibility, dailySummary: dailySummary)
        
        print(chanceOfRainAsDouble)
        DispatchQueue.main.async {
            self.currentTempLabel.text = "\(currentTemp)°"
            self.currentSummaryLabel.text = currentSummary
            self.chanceOfRainLabel.text = "\(chanceOfRain)%"
            self.humidityLabel.text = "\(humidity)%"
            self.visibilityLabel.text = "\(visibility) km"
            self.dailySummaryLabel.text = dailySummary
        }
    }
    
    func didFailWithError(error: Error) {
        print("\nThere was an error in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
    }
}

// MARK: - Location Manager Delegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\nThere was an error in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
    }
}
