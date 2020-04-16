//
//  WeatherManager.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

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
        locationObject.weatherObjects.append(weatherObject)
        
        saveToPersistentStore()
    }
    
    func updateWeatherObject(_ weatherObject: WeatherObject, currentTemp: Int, currentSummary: String, chanceOfRain: Int, humidity: Int, visibility: Double, dailySummary: String, icon: String, hourlyWeather: [HourlyData], dailyWeather: [DailyData]) {

        weatherObject.currentTemp = currentTemp
        weatherObject.currentSummary = currentSummary
        weatherObject.chanceOfRain = chanceOfRain
        weatherObject.humidity = humidity
        weatherObject.visibility = visibility
        weatherObject.dailySummary = dailySummary
        weatherObject.icon = icon
        weatherObject.hourlyWeather = hourlyWeather
        weatherObject.dailyWeather = dailyWeather
        
        saveToPersistentStore()
    }
    
    func updateWeatherObject(with weatherObject: WeatherObject, location: KDTLocationObject) {
        if location.weatherObjects.first != nil {
            location.weatherObjects[0] = weatherObject
        }
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
        // Attempt to convert our playlists to JSON
        do {
            let jsonCities = try jsonEncoder.encode(cities)
            // With the new json(d) Playlist, save it to the users device
            try jsonCities.write(to: createFileURLForPersistence())
        } catch let encodingError {
            // Handle the error, if there is one
            print("There was an error saving!! \(encodingError.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() {
        // The data we want will be JSON, and I want it to be a Playlist.
        let jsonDecoder = JSONDecoder()
        //Decode the data
        do {
            let jsonData = try Data(contentsOf: createFileURLForPersistence())
            let decodedCities = try jsonDecoder.decode([KDTLocationObject].self, from: jsonData)
            cities = decodedCities
        } catch let error {
            print("\nThere was an error decoding in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
//            print("There was an error decoding!! \(decodingError.localizedDescription)")
        }
    }
}


