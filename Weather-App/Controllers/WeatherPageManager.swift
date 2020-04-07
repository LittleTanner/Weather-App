//
//  WeatherPageManager.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

protocol WeatherPageManagerDelegate {
    func reloadTableView()
}

class WeatherPageManager {
    
    static let shared = WeatherPageManager()
    
    var cities: [City] = [City(cityName: "Newhall", latitude: 34.3578323, longitude: -118.4972295),
                          City(cityName: "Seattle", latitude: 47.603363, longitude: -122.330417),
                          City(cityName: "Denver", latitude: 39.739212, longitude: -104.9903028)]
    
    func addCity(with city: City) {
        cities.append(city)
    }
    
    func removeCity(with city: City) {
        guard let cityToRemove = cities.firstIndex(of: city) else { return }
        cities.remove(at: cityToRemove)
    }
}


