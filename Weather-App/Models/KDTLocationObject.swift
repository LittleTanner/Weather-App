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
    
    var weatherObjects: [WeatherObject]
    
    init(cityName: String, latitude: Double, longitude: Double, weatherObjects: [WeatherObject] = []) {
        self.cityName = cityName
        self.latitude = latitude
        self.longitude = longitude
        self.weatherObjects = weatherObjects
    }
}

extension KDTLocationObject: Equatable {
    static func == (lhs: KDTLocationObject, rhs: KDTLocationObject) -> Bool {
        return lhs.cityName == rhs.cityName && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
