//
//  LocationViewController.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/25/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var hourlyOrDailySegmentedControl: UISegmentedControl!
    
    let locationManager = CLLocationManager()
    
    var city: KDTLocationObject?
    var cityLabelText: String?
    var hourlySelected: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentTempLabel.text = updateCurrentTemp()
        currentSummaryLabel.text = updateCurrentSummary()
        
        if let cityWeather = city?.weatherObject {
            updateWeatherUI(with: cityWeather)
        }
        
        if findPageIndex() == 0 {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        } else {
            updateWeather()
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        updateWeather()
    }
    
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // The hourly button is selected
            hourlySelected = true
            weatherCollectionView.reloadData()
            weatherCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        } else {
            // The daily button is selected
            hourlySelected = false
            weatherCollectionView.reloadData()
            weatherCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        }
    }
    
    func setupUI() {
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        
        hourlyOrDailySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        hourlyOrDailySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        
        registerCollectionViewCells()
        
        cityNameLabel.text = cityLabelText
    }
    
    func registerCollectionViewCells() {
        let hourlyNib = UINib(nibName: Constants.hourlyWeatherCell, bundle: nil)
        weatherCollectionView.register(hourlyNib, forCellWithReuseIdentifier: Constants.hourlyWeatherCellIdentifier)
        
        let dailyNib = UINib(nibName: Constants.dailyWeatherCell, bundle: nil)
        weatherCollectionView.register(dailyNib, forCellWithReuseIdentifier: Constants.dailyWeatherCellIdentifier)
    }
    
    func updateCurrentTemp() -> String {
        guard let currentTemp = WeatherManager.shared.cities[findPageIndex()].weatherObject?.currentTemp else { return "" }
        return "\(currentTemp)°"
    }
    
    func updateCurrentSummary() -> String {
        guard let currentSummary = WeatherManager.shared.cities[findPageIndex()].weatherObject?.currentSummary else { return "" }
        return currentSummary
    }
    
    
    func updateWeatherUI(with weatherObject: WeatherObject) {
        let backgroundImage = weatherObject.getBackgroundImage(for: weatherObject.icon)
        
        DispatchQueue.main.async {
            self.currentTempLabel.text = "\(weatherObject.currentTemp)°"
            self.currentSummaryLabel.text = weatherObject.currentSummary
            self.weatherCollectionView.reloadData()
            self.backgroundImageView.image = backgroundImage
        }
    }
    
    func updateWeather() {
        let location = WeatherManager.shared.cities[findPageIndex()]
            
            WeatherNetworkManager().getWeather(latitude: location.latitude, longitude: location.longitude) { (weatherObject) in
                guard let newWeatherObject = weatherObject else { return }
                
                let currentTemp = newWeatherObject.currentTemp
                let currentSummary = newWeatherObject.currentSummary
                let icon = newWeatherObject.icon
                
                if let weatherObject = location.weatherObject {
                    WeatherManager.shared.updateWeatherObject(weatherObject, currentTemp: currentTemp, currentSummary: currentSummary, icon: icon, hourlyWeather: newWeatherObject.hourlyWeather, dailyWeather: newWeatherObject.dailyWeather)
                } else {
                    WeatherManager.shared.addWeatherObject(newWeatherObject, toLocationObject: location)
                }
                
                self.updateWeatherUI(with: newWeatherObject)
            }
        
    }
    
    
//    func updateWeather() {
//        if let location = city {
//
//            WeatherNetworkManager().getWeather(latitude: location.latitude, longitude: location.longitude) { (weatherObject) in
//                guard let newWeatherObject = weatherObject else { return }
//
//                let currentTemp = newWeatherObject.currentTemp
//                let currentSummary = newWeatherObject.currentSummary
//                let icon = newWeatherObject.icon
//
//                if let weatherObject = location.weatherObject {
//                    WeatherManager.shared.updateWeatherObject(weatherObject, currentTemp: currentTemp, currentSummary: currentSummary, icon: icon, hourlyWeather: newWeatherObject.hourlyWeather, dailyWeather: newWeatherObject.dailyWeather)
//                } else {
//                    WeatherManager.shared.addWeatherObject(newWeatherObject, toLocationObject: location)
//                }
//
//                self.updateWeatherUI(with: newWeatherObject)
//            }
//        }
//    }
    
    
    func findPageIndex() -> Int {
        guard let city = city, let indexOfCity = WeatherManager.shared.cities.firstIndex(of: city) else { return 0 }
        return indexOfCity
    }
}

// MARK: - Location Manager Delegate

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Get weather for current location
        if let location = locations.last {
            WeatherManager.getCityName(from: location) { (placemarks) in
                
                if let firstLocation = placemarks?.locality, let city = self.city {
                    DispatchQueue.main.async {
                        self.cityNameLabel.text = firstLocation
                    }
                    WeatherManager.shared.updateCity(with: firstLocation, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, location: city)
                }
            }
            
            updateWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\nThere was an error in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
    }
}

// MARK: - Collection View Methods

extension LocationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let weatherObject = city?.weatherObject else { return 0 }
        if hourlySelected {
            return weatherObject.hourlyWeather.count
        } else {
            return weatherObject.dailyWeather.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if hourlySelected {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.hourlyWeatherCellIdentifier, for: indexPath) as? HourlyWeatherCollectionViewCell else { return UICollectionViewCell() }
            
            if let city = city {
                
                cell.configure(with: city, indexPath: indexPath)
                
                return cell
            }
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.dailyWeatherCellIdentifier, for: indexPath) as? DailyWeatherCollectionViewCell else { return UICollectionViewCell() }
            
            if let city = city {
                
                cell.configure(with: city, indexPath: indexPath)
                
                return cell
            }
        }
        return UICollectionViewCell()
    }
}
