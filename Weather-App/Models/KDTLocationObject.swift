//
//  City.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import Foundation

class KDTLocationObject: Codable {
    var cityName: String
    var latitude: Double
    var longitude: Double
    
    var weatherObject: WeatherObject?
    
    init(cityName: String, latitude: Double, longitude: Double, weatherObject: WeatherObject? = nil) {
        self.cityName = cityName
        self.latitude = latitude
        self.longitude = longitude
        self.weatherObject = weatherObject
    }
}

// MARK: - Equatable

extension KDTLocationObject: Equatable {
    static func == (lhs: KDTLocationObject, rhs: KDTLocationObject) -> Bool {
        return lhs.cityName == rhs.cityName && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
