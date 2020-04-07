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
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var chanceOfRainLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var dailySummaryLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    var city: City?
    var cityLabelText: String?
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    var weatherObject: WeatherObject?
    var hourlySelected: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        weatherManager.delegate = self
        
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
//        let hourlyNib = UINib(nibName: Constants.hourlyWeatherCell, bundle: nil)
//        weatherCollectionView.register(hourlyNib, forCellWithReuseIdentifier: Constants.hourlyWeatherCellIdentifier)
        
        let dailyNib = UINib(nibName: Constants.dailyWeatherCell, bundle: nil)
        weatherCollectionView.register(dailyNib, forCellWithReuseIdentifier: Constants.dailyWeatherCellIdentifier)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        cityNameLabel.text = cityLabelText
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {

    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // The hourly button is selected
            hourlySelected = true
            weatherCollectionView.reloadData()
            weatherCollectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .left, animated: false)
        } else {
            // The daily button is selected
            hourlySelected = false
            weatherCollectionView.reloadData()
            weatherCollectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .left, animated: false)
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
//            self.backgroundImageView.image = backgroundImage
            self.backgroundImageView.image = UIImage(named: Constants.rain)
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
        
        if let location = city {
            let latitude = location.latitude
            let longitude = location.longitude
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
        }
        
//        if let location = locations.last {
//            let latitude = location.coordinate.latitude
//            let longitude = location.coordinate.longitude
//            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
//        }
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.dailyWeatherCellIdentifier, for: indexPath) as? DailyWeatherCollectionViewCell else { return UICollectionViewCell() }
            
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
                
                cell.dayLabel.text = time
                cell.weatherIconLabel.text = WeatherManager.getWeatherIcon(with: indexForObject.icon)
                cell.tempHighLabel.text = "\(Int(indexForObject.temperature))°"
                cell.tempLowLabel.text = ""
                cell.rainLabel.text = "☂️ \(rainAsInt)%"
                
                
                return cell
            }
            
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.hourlyWeatherCellIdentifier, for: indexPath) as? HourlyWeatherCollectionViewCell else { return UICollectionViewCell() }
//
//            if let weatherObject = weatherObject {
//                let indexForObject = weatherObject.hourlyWeather[indexPath.row]
//
//                let rainAsDouble = indexForObject.precipProbability * 100
//                let rainAsInt = Int(rainAsDouble)
//
//                let unixTimestampAsDouble = Double(indexForObject.time)
//                let date = Date(timeIntervalSince1970: unixTimestampAsDouble)
//                let dateFormatter = DateFormatter()
//                let timezone = TimeZone.current.abbreviation() ?? "PST"
//                dateFormatter.timeZone = TimeZone(abbreviation: timezone)
//                dateFormatter.locale = NSLocale.current
//                dateFormatter.dateFormat = "h a"
//                let time = dateFormatter.string(from: date)
//
//                let weatherIcon = indexForObject.icon
//
//                switch weatherIcon {
//                case Constants.clearDay: cell.weatherIcon.text = "☀️"
//                case Constants.clearNight: cell.weatherIcon.text = "🌙"
//                case Constants.rain: cell.weatherIcon.text = "🌧"
//                case Constants.snow: cell.weatherIcon.text = "🌨"
//                case Constants.sleet: cell.weatherIcon.text = "🌨"
//                case Constants.wind: cell.weatherIcon.text = "💨"
//                case Constants.fog: cell.weatherIcon.text = "🌫"
//                case Constants.cloudy: cell.weatherIcon.text = "☁️"
//                case Constants.partlyCloudyDay: cell.weatherIcon.text = "⛅️"
//                case Constants.partlyCloudyNight: cell.weatherIcon.text = "🌥"
//                default: cell.weatherIcon.text = "🤷🏼‍♂️"
//                }
//
//                cell.timeLabel.text = time
//                cell.tempLabel.text = "\(Int(indexForObject.temperature))°"
//                cell.rainLabel.text = "Rain: \(rainAsInt)%"
//
//
//                return cell
//            }
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.dailyWeatherCellIdentifier, for: indexPath) as? DailyWeatherCollectionViewCell else { return UICollectionViewCell() }
            
            if let weatherObject = weatherObject {
                let indexForObject = weatherObject.dailyWeather[indexPath.row]
                
                let rainAsDouble = indexForObject.precipProbability * 100
                let rainAsInt = Int(rainAsDouble)
                
                let unixTimestampAsDouble = Double(indexForObject.time)
                let date = Date(timeIntervalSince1970: unixTimestampAsDouble)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE"
                let day = dateFormatter.string(from: date)
                
                cell.dayLabel.text = day
                cell.weatherIconLabel.text = WeatherManager.getWeatherIcon(with: indexForObject.icon)
                cell.rainLabel.text = "☂️ \(rainAsInt)%"
                cell.tempHighLabel.text = "\(Int(indexForObject.temperatureHigh))°"
                cell.tempLowLabel.text = "\(Int(indexForObject.temperatureLow))°"
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
