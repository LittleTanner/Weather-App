//
//  WeatherManager.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func reloadTableView()
}

class WeatherManager {
    
    static let shared = WeatherManager()
    
    var cities: [KDTLocationObject] = [KDTLocationObject(cityName: "Cupertino", latitude: 37.3230, longitude: -122.0322)]
    
    
    var pageControllers: [UIViewController] = []
    var pageIndex: Int = 0
    
    func addCity(with city: KDTLocationObject) {
        cities.append(city)
        
        saveToPersistentStore()
    }
    
    func updateCity(with cityName: String, latitude: Double, longitude: Double, location: KDTLocationObject) {
        location.cityName = cityName
        location.latitude = latitude
        location.longitude = longitude
        
        saveToPersistentStore()
    }
    
    func removeCity(with city: KDTLocationObject) {
        guard let cityToRemove = cities.firstIndex(of: city) else { return }
        cities.remove(at: cityToRemove)
        
        saveToPersistentStore()
    }
    
    
    func addWeatherObject(_ weatherObject: WeatherObject, toLocationObject locationObject: KDTLocationObject) {
        locationObject.weatherObject = weatherObject
        
        saveToPersistentStore()
    }
    
    func updateWeatherObject(_ weatherObject: WeatherObject, currentTemp: Int, currentSummary: String, icon: String, hourlyWeather: [HourlyData], dailyWeather: [DailyData]) {

        weatherObject.currentTemp = currentTemp
        weatherObject.currentSummary = currentSummary
        weatherObject.icon = icon
        weatherObject.hourlyWeather = hourlyWeather
        weatherObject.dailyWeather = dailyWeather
        
        saveToPersistentStore()
    }
    
    func updateWeatherObject(with weatherObject: WeatherObject, location: KDTLocationObject) {
        if location.weatherObject != nil {
            location.weatherObject = weatherObject
        }
    }
    
    // MARK: - Helper Methods
    
    static func getCoordinates(from addressString: String, completionHandler: @escaping((info: String, coordinates: CLLocationCoordinate2D), NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    var outputString = ""
                    
                    if let city = placemark.locality,
                        let state = placemark.administrativeArea,
                        let country = placemark.isoCountryCode {
                        outputString = "\(city), \(state), \(country)"
                    }
                    
                    completionHandler((outputString, location.coordinate), nil)
                    return
                }
            }

            completionHandler(("Location not found", kCLLocationCoordinate2DInvalid), error as NSError?)
        }
    }

    static func getCityName(from location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void ) {
        
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }
            else {
                // An error occurred during geocoding.
                completionHandler(nil)
            }
        })
    }
    
    
    
    
    // MARK: - Persistence
    // Return to us a URL that we can save data too createFileURLForPersistence
    func createFileURLForPersistence() -> URL {
        // Grab the users document directory
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // Create the new fileURL on user's phone
        let fileURL = urls[0].appendingPathComponent("WeatherLocations.json")
        
        return fileURL
    }
    
    func saveToPersistentStore() {
        // Create an instance of JSON Encoder
        let jsonEncoder = JSONEncoder()
        // Attempt to convert our cities to JSON
        do {
            let jsonCities = try jsonEncoder.encode(cities)
            // With the new json(d) cities, save it to the users device
            try jsonCities.write(to: createFileURLForPersistence())
        } catch let error {
            // Handle the error, if there is one
            print("\nThere was an error saving data in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
        }
    }
    
    func loadFromPersistentStore() {
        // The data we want will be JSON, and I want it to be a KDTLocationObject.
        let jsonDecoder = JSONDecoder()
        //Decode the data
        do {
            let jsonData = try Data(contentsOf: createFileURLForPersistence())
            let decodedCities = try jsonDecoder.decode([KDTLocationObject].self, from: jsonData)
            cities = decodedCities
        } catch let error {
            print("\nThere was an error decoding in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
        }
    }
}


