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
    @IBOutlet weak var tableView: UITableView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    var weatherData: WeatherData?
    var dailySummaries: [DailyData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        weatherManager.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
    }

    @IBAction func fetchButtonTapped(_ sender: UIButton) {
        locationManager.requestLocation()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
//        weatherManager.fetchWeather(latitude: 37.8267, longitude: -122.4233)
    }
    
    func setDailyWeather() {
        
    }
    
}

extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherData) {
        
        weatherData = weather
        
        if let weatherTest = weather.daily?.data {
            dailySummaries = weatherTest
            DispatchQueue.main.async {
                self.currentTempLabel.text = weatherTest[0].summary
            }
        }
        
        
    }
    
    func didFailWithError(error: Error) {
        print("\nThere was an error in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
    }
}

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


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let weatherData = weatherData,
            let dailyWeather = weatherData.daily {
            return dailyWeather.data.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        if let weatherData = weatherData,
//            let dailySummaries = weatherData.daily?.data {
//            cell.textLabel?.text = dailySummaries[indexPath.row].summary
//        }
        if let dailySummaries = dailySummaries {
            cell.textLabel?.text = dailySummaries[indexPath.row].summary
        }
        
        return cell
    }
    
    
}
