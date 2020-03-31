//
//  SearchByAddressViewController.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/27/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit
import CoreLocation

class SearchByAddressViewController: UIViewController {

    @IBOutlet weak var searchByAddressSearchBar: UISearchBar!
    @IBOutlet weak var addressesTableView: UITableView!
    
    var searchBarText: String?
    var lat: Double?
    var lon: Double?
    var weatherManager = WeatherManager()
    
    var weatherObject: WeatherObject?
    var testLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchByAddressSearchBar.delegate = self
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
//    func getCoordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
//        let geocoder = CLGeocoder()
//
//        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
//            if error == nil {
//                if let placemark = placemarks?[0] {
//                    let location = placemark.location!
//                    print("Placemark\n name:\(placemark.name)\n City:\(placemark.locality)\n State:\(placemark.administrativeArea)\n Country: \(placemark.isoCountryCode)")
//                    completionHandler(location.coordinate, nil)
//                    return
//                }
//            }
//
//            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
//        }
//    }
    
    func getCoordinate(addressString: String, completionHandler: @escaping((info: String, coordinates: CLLocationCoordinate2D), NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    let outputString = "\(placemark.locality ?? "N/A"), \(placemark.administrativeArea ?? "N/A"), \(placemark.isoCountryCode ?? "N/A")"
                    print("Placemark\n name:\(placemark.name)\n City:\(placemark.locality)\n State:\(placemark.administrativeArea)\n Country: \(placemark.isoCountryCode)")
                    completionHandler((outputString, location.coordinate), nil)
                    return
                }
            }
            
            completionHandler(("Error", kCLLocationCoordinate2DInvalid), error as NSError?)
        }
    }
}

extension SearchByAddressViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.addressCell, for: indexPath)
        
        if let weatherObject = weatherObject, let locationInfo = testLocation {
        
            cell.textLabel?.text = locationInfo
            cell.detailTextLabel?.text = String(weatherObject.currentTemp)
            
        }
        
        return cell
    }
}

extension SearchByAddressViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            self.searchBarText = searchText
            getCoordinate(addressString: searchText) { (coordinate, error) in
                self.lat = coordinate.coordinates.latitude
                self.lon = coordinate.coordinates.longitude
                if let latitude = self.lat, let longitude = self.lon {
                    print("\(latitude) \(longitude)")
                    self.weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
                }
                self.testLocation = coordinate.info
            }
        }
        searchBar.resignFirstResponder()
    }
}

extension SearchByAddressViewController: WeatherManagerDelegate {
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
        let icon = currentWeather.icon
        
//        weatherObject = WeatherObject(currentTemp: currentTemp, currentSummary: currentSummary, chanceOfRain: chanceOfRain, humidity: humidity, visibility: visibility, dailySummary: dailySummary, icon: icon)
        DispatchQueue.main.async {
            self.addressesTableView.reloadData()
        }
        
    }
    
    func didFailWithError(error: Error) {
        // Handle error
    }
    
    
}
