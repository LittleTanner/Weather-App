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
    
    var cities: [City] = []
    
    func addCity(with city: City) {
        cities.append(city)
    }
    
    func removeCity(with city: City) {
        guard let cityToRemove = cities.firstIndex(of: city) else { return }
        cities.remove(at: cityToRemove)
    }
}


