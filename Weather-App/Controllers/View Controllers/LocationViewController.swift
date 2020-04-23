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
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var fetchingWeatherIndicator: UIActivityIndicatorView!
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
        
        if let cityWeather = city?.weatherObject {
            updateUI(with: cityWeather)
        }
        
        checkIfLocationServicesAllowed()
        determineHowToUpdateWeather()
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: Constants.locationsNavigationControllerID) as? LocationsNavigationController else { return }
        vc.modalPresentationStyle = .fullScreen
        
        presentVCFromRight(vc)
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        determineHowToUpdateWeather()
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
        hourlyOrDailySegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.label], for: .normal)
        
        registerCollectionViewCells()
        
        cityNameLabel.text = cityLabelText
    }
    
    func registerCollectionViewCells() {
        let hourlyNib = UINib(nibName: Constants.hourlyWeatherCell, bundle: nil)
        weatherCollectionView.register(hourlyNib, forCellWithReuseIdentifier: Constants.hourlyWeatherCellIdentifier)
        
        let dailyNib = UINib(nibName: Constants.dailyWeatherCell, bundle: nil)
        weatherCollectionView.register(dailyNib, forCellWithReuseIdentifier: Constants.dailyWeatherCellIdentifier)
    }
    
    func updateUI(with weatherObject: WeatherObject) {
        let backgroundImage = weatherObject.getBackgroundImage(for: weatherObject.icon)
        
        DispatchQueue.main.async {
            self.currentTempLabel.text = "\(weatherObject.currentTemp)°"
            self.currentSummaryLabel.text = weatherObject.currentSummary
            self.weatherCollectionView.reloadData()
            self.backgroundImageView.image = backgroundImage
            self.fetchingWeatherIndicator.stopAnimating()
            self.refreshButton.isHidden = false
        }
    }
    
    func updateWeather() {
        let location = WeatherManager.shared.cities[findPageIndex()]
        
        WeatherNetworkManager().getWeather(latitude: location.latitude, longitude: location.longitude) { (weatherObject) in
            guard let newWeatherObject = weatherObject else {
                DispatchQueue.main.async {
                    self.presentAlert(with: "An Error Has Occurred", message: "Please try again later. Maybe check your internet connection.", actionButtonTitle: "Ok")
                }
                return
            }
            
            let currentTemp = newWeatherObject.currentTemp
            let currentSummary = newWeatherObject.currentSummary
            let icon = newWeatherObject.icon
            
            if let weatherObject = location.weatherObject {
                WeatherManager.shared.updateWeatherObject(weatherObject, currentTemp: currentTemp, currentSummary: currentSummary, icon: icon, hourlyWeather: newWeatherObject.hourlyWeather, dailyWeather: newWeatherObject.dailyWeather)
            } else {
                WeatherManager.shared.addWeatherObject(newWeatherObject, toLocationObject: location)
            }
            
            self.updateUI(with: newWeatherObject)
        }
        
    }
    
    func checkIfLocationServicesAllowed() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                // Location Access Allowed
                WeatherManager.shared.allowsLocation = true
            default:
                // Location Access Denied / Other
                WeatherManager.shared.allowsLocation = false
            }
        }
    }
    
    func determineHowToUpdateWeather() {
        refreshButton.isHidden = true
        fetchingWeatherIndicator.startAnimating()
        
        if findPageIndex() == 0 && WeatherManager.shared.allowsLocation == true {
            locationManager.delegate = self
            locationManager.requestLocation()
        } else {
            updateWeather()
        }
    }
    
    func findPageIndex() -> Int {
        guard let city = city, let indexOfCity = WeatherManager.shared.cities.firstIndex(of: city) else { return 0 }
        return indexOfCity
    }
}

// MARK: - Location Manager Delegate

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Get current location
        if let location = locations.last {
            // Get city name
            WeatherManager.getCityName(from: location) { (placemarks) in
                
                if let cityName = placemarks?.locality, let city = self.city {
                    DispatchQueue.main.async {
                        self.cityNameLabel.text = cityName
                    }
                    WeatherManager.shared.updateCity(with: cityName, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, location: city)
                    
                    self.updateWeather()
                }
            }
            
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
