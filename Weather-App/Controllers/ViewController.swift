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
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var hourlyOrDailySegmentedControl: UISegmentedControl!
    
//    let locationManager = CLLocationManager()
    
    var city: KDTLocationObject?
    var cityLabelText: String?
    var hourlySelected: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourlyOrDailySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        hourlyOrDailySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        
//        locationManager.delegate = self
        
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        
        let hourlyNib = UINib(nibName: Constants.hourlyWeatherCell, bundle: nil)
        weatherCollectionView.register(hourlyNib, forCellWithReuseIdentifier: Constants.hourlyWeatherCellIdentifier)
        
        let dailyNib = UINib(nibName: Constants.dailyWeatherCell, bundle: nil)
        weatherCollectionView.register(dailyNib, forCellWithReuseIdentifier: Constants.dailyWeatherCellIdentifier)
        
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
        
        cityNameLabel.text = cityLabelText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWeather()
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
    
    func updateWeather() {
        if let location = city {
            
            WeatherManager().getWeather(latitude: location.latitude, longitude: location.longitude) { (weatherObject) in
                guard let weatherObject = weatherObject else { return }
                
                let currentTemp = Int(weatherObject.currentTemp)
                let currentSummary = weatherObject.currentSummary
                let chanceOfRain = weatherObject.chanceOfRain
                let humidity = weatherObject.humidity
                let visibility = weatherObject.visibility
                let icon = weatherObject.icon
                
                if let weatherObject = location.weatherObjects.first {
                    WeatherPageManager.shared.updateWeatherObject(weatherObject, currentTemp: currentTemp, currentSummary: currentSummary, chanceOfRain: chanceOfRain, humidity: humidity, visibility: visibility, dailySummary: weatherObject.dailySummary, icon: icon, hourlyWeather: weatherObject.hourlyWeather, dailyWeather: weatherObject.dailyWeather)
                }
                
                WeatherPageManager.shared.addWeatherObject(weatherObject, toLocationObject: location)
                
                let backgroundImage = weatherObject.getImageForCurrent(for: weatherObject.icon)
                
                DispatchQueue.main.async {
                    self.currentTempLabel.text = "\(currentTemp)°"
                    self.currentSummaryLabel.text = currentSummary
                    self.weatherCollectionView.reloadData()
                    //                    self.backgroundImageView.image = backgroundImage
                    self.backgroundImageView.image = UIImage(named: Constants.rain)
                }
            }
        }
    }
    
}

// MARK: - Location Manager Delegate

//extension ViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        //  Get weather for current location
//        //        if let location = locations.last {
//        //            let latitude = location.coordinate.latitude
//        //            let longitude = location.coordinate.longitude
//        //            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
//        //        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("\nThere was an error in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
//    }
//}

// MARK: - Collection View Methods

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let weatherObject = city?.weatherObjects.first else { return 0 }
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.hourlyWeatherCellIdentifier, for: indexPath) as? HourlyWeatherCollectionViewCell else { return UICollectionViewCell() }
            
            if let city = city {
                if let indexForObject = city.weatherObjects.first?.hourlyWeather[indexPath.row] {
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
                    cell.weatherIcon.image = WeatherManager.getWeatherIcon(with: indexForObject.icon)
                    cell.tempLabel.text = "\(Int(indexForObject.temperature))°"
                    cell.rainLabel.text = "\(rainAsInt)%"
                    
                    return cell
                }
            }
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.dailyWeatherCellIdentifier, for: indexPath) as? DailyWeatherCollectionViewCell else { return UICollectionViewCell() }
            
            if let city = city {
                if let indexForObject = city.weatherObjects.first?.dailyWeather[indexPath.row] {
                    
                    let rainAsDouble = indexForObject.precipProbability * 100
                    let rainAsInt = Int(rainAsDouble)
                    
                    let unixTimestampAsDouble = Double(indexForObject.time)
                    let date = Date(timeIntervalSince1970: unixTimestampAsDouble)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEE"
                    let day = dateFormatter.string(from: date)
                    
                    cell.dayLabel.text = day
                    cell.weatherIconImageView.image = WeatherManager.getWeatherIcon(with: indexForObject.icon)
                    cell.rainLabel.text = "\(rainAsInt)%"
                    cell.tempHighLabel.text = "\(Int(indexForObject.temperatureHigh))°"
                    cell.tempLowLabel.text = "\(Int(indexForObject.temperatureLow))°"
                    
                    return cell
                }
            }
        }
        return UICollectionViewCell()
    }
}
