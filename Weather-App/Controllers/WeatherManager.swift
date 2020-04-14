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
    
    var cities: [KDTLocationObject] = [KDTLocationObject(cityName: "Newhall", latitude: 34.3578323, longitude: -118.4972295),
                          KDTLocationObject(cityName: "Seattle", latitude: 47.603363, longitude: -122.330417),
                          KDTLocationObject(cityName: "Denver", latitude: 39.739212, longitude: -104.9903028)]
    
    
    var pageControllers: [UIViewController] = []
    var pageIndex: Int = 0
    
    func addCity(with city: KDTLocationObject) {
        cities.append(city)
    }
    
    func removeCity(with city: KDTLocationObject) {
        guard let cityToRemove = cities.firstIndex(of: city) else { return }
        cities.remove(at: cityToRemove)
    }
    
    
    func addWeatherObject(_ weatherObject: WeatherObject, toLocationObject locationObject: KDTLocationObject) {
        locationObject.weatherObjects.append(weatherObject)
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
    }
}


