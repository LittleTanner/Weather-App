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
    var hourlySelected: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        weatherManager.delegate = self
        
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        let hourlyNib = UINib(nibName: "HourlyWeatherCollectionViewCell", bundle: nil)
        weatherCollectionView.register(hourlyNib, forCellWithReuseIdentifier: "hourlyWeatherCellXIB")
        
        let dailyNib = UINib(nibName: "DailyWeatherCollectionViewCell", bundle: nil)
        weatherCollectionView.register(dailyNib, forCellWithReuseIdentifier: "dailyWeatherCellXIB")
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // The hourly button is selected
            hourlySelected = true
            weatherCollectionView.reloadData()
            weatherCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        } else {
            // The daily button is selected
            hourlySelected = false
            weatherCollectionView.reloadData()
            weatherCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        }
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
        
        guard let weatherObject = self.weatherObject else { return }
        let backgroundImage = weatherObject.getImageForCurrent(for: weatherObject.icon)
        
        DispatchQueue.main.async {
            self.currentTempLabel.text = "\(currentTemp)°"
            self.currentSummaryLabel.text = currentSummary
            self.chanceOfRainLabel.text = "\(chanceOfRain)%"
            self.humidityLabel.text = "\(humidity)%"
            self.visibilityLabel.text = "\(visibility) km"
            self.dailySummaryLabel.text = dailySummary
            self.weatherCollectionView.reloadData()
            self.backgroundImageView.image = backgroundImage
        }
    }
    
    func didFailWithError(error: Error) {
        // Show an alert saying there was an error fetching weather data at this time
        let alert = UIAlertController(title: "Weather Forecast Missing", message: "Can't fetch the weather right now. Please try again later.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
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
        guard let weatherObject = weatherObject else { return 0 }
        if hourlySelected == true {
            print(weatherObject.hourlyWeather.count)
            return weatherObject.hourlyWeather.count
        } else {
            print(weatherObject.dailyWeather.count)
            return weatherObject.dailyWeather.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if hourlySelected == true {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyWeatherCellXIB", for: indexPath) as? HourlyWeatherCollectionViewCell else { return UICollectionViewCell() }
            
            if let weatherObject = weatherObject {
                let indexForObject = weatherObject.hourlyWeather[indexPath.row]
                
                let rainAsDouble = indexForObject.precipProbability * 100
                let rainAsInt = Int(rainAsDouble)
                
                let unixTimestampAsDouble = Double(indexForObject.time)
                let date = Date(timeIntervalSince1970: unixTimestampAsDouble)
                let dateFormatter = DateFormatter()
                let timezone = TimeZone.current.abbreviation() ?? "PST"
                dateFormatter.timeZone = TimeZone(abbreviation: timezone)
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "h a"
                let time = dateFormatter.string(from: date)
                
                
                cell.timeLabel.text = time
                cell.tempLabel.text = "\(Int(indexForObject.temperature))°"
                cell.rainLabel.text = "Rain: \(rainAsInt)%"
                
                return cell
            }
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dailyWeatherCellXIB", for: indexPath) as? DailyWeatherCollectionViewCell else { return UICollectionViewCell() }
            
            if let weatherObject = weatherObject {
                let indexForObject = weatherObject.dailyWeather[indexPath.row]
                
                let rainAsDouble = indexForObject.precipProbability * 100
                let rainAsInt = Int(rainAsDouble)
                
                let unixTimestampAsDouble = Double(indexForObject.time)
                let date = Date(timeIntervalSince1970: unixTimestampAsDouble)
                let dateFormatter = DateFormatter()
                let timezone = TimeZone.current.abbreviation() ?? "PST"
                dateFormatter.timeZone = TimeZone(abbreviation: timezone)
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "EEEE"
                let day = dateFormatter.string(from: date)
                
                dateFormatter.dateFormat = "h:m a"
                let sunriseTimeAsDouble = Double(indexForObject.sunriseTime)
                let sunriseDate = Date(timeIntervalSinceNow: sunriseTimeAsDouble)
                let sunrise = dateFormatter.string(from: sunriseDate)
                
                let sunsetTimeAsDouble = Double(indexForObject.sunsetTime)
                let sunsetDate = Date(timeIntervalSinceNow: sunsetTimeAsDouble)
                let sunset = dateFormatter.string(from: sunsetDate)
                
                
                cell.dayLabel.text = day
                cell.rainLabel.text = "Rain: \(rainAsInt)%"
                cell.tempHighLabel.text = "\(Int(indexForObject.temperatureHigh))°"
                cell.tempLowLabel.text = "\(Int(indexForObject.temperatureLow))°"
                cell.sunriseLabel.text = sunrise
                cell.sunsetLabel.text = sunset
                cell.weatherIconLabel.text = "🌧"
                
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
