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
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    
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
        
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        let nib = UINib(nibName: "HourlyWeatherCollectionViewCell", bundle: nil)
        weatherCollectionView.register(nib, forCellWithReuseIdentifier: "hourlyWeatherCellXIB")
    }
}

// MARK: - Weather Manager Delegate

extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherData) {
        
        guard let currentWeather = weather.currently,
              let dailyWeather = weather.daily,
            let dailySummary = dailyWeather.data.first?.summary,
            let hourlyWeather = weather.hourly?.data,
        let dailyWeatherData = weather.daily?.data else { return }
        
        let currentTemp = Int(currentWeather.temperature)
        let currentSummary = currentWeather.summary
        let chanceOfRainAsDouble = currentWeather.precipProbability * 100.0
        let chanceOfRain = Int(chanceOfRainAsDouble)
        let humidityAsDouble = currentWeather.humidity * 100.0
        let humidity = Int(humidityAsDouble)
        let visibility = currentWeather.visibility
        let icon = currentWeather.icon
        
        weatherObject = WeatherObject(currentTemp: currentTemp, currentSummary: currentSummary, chanceOfRain: chanceOfRain, humidity: humidity, visibility: visibility, dailySummary: dailySummary, icon: icon, hourlyWeather: hourlyWeather, dailyWeather: dailyWeatherData)

        DispatchQueue.main.async {
            self.currentTempLabel.text = "\(currentTemp)°"
            self.currentSummaryLabel.text = currentSummary
            self.chanceOfRainLabel.text = "\(chanceOfRain)%"
            self.humidityLabel.text = "\(humidity)%"
            self.visibilityLabel.text = "\(visibility) km"
            self.dailySummaryLabel.text = dailySummary
            self.weatherCollectionView.reloadData()
            if let weatherObject = self.weatherObject {
                self.backgroundImageView.image = weatherObject.getImageForCurrent(for: weatherObject.icon)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        // Show an alert saying there was an error fetching weather data at this time
        let alert = UIAlertController(title: "Weather Forecast Missing", message: "Can't fetch the weather right now. Please try again later.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
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

// MARK: - Collection View Methods

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let weatherObject = weatherObject {
            print(weatherObject.hourlyWeather.count)
            return weatherObject.hourlyWeather.count
        } else {
            print("No hourly data")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyWeatherCellXIB", for: indexPath) as? HourlyWeatherCollectionViewCell else { return UICollectionViewCell() }
        
        if let weatherObject = weatherObject {
            let indexForObject = weatherObject.hourlyWeather[indexPath.row]
            
            cell.timeLabel.text = String(indexForObject.time)
            cell.tempLabel.text = "\(indexForObject.temperature)°"
            cell.rainLabel.text = "Rain: \(indexForObject.precipProbability)"
        }
        
        return cell
    }
}
