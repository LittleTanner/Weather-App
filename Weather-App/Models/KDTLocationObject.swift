//
//  City.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import Foundation

class KDTLocationObject {
    let cityName: String
    var state: String?
    let latitude: Double
    let longitude: Double
    
    var weatherObjects: [WeatherObject]
    
    init(cityName: String, state: String? = nil, latitude: Double, longitude: Double, weatherObjects: [WeatherObject] = []) {
        self.cityName = cityName
        self.state = state
        self.latitude = latitude
        self.longitude = longitude
        self.weatherObjects = weatherObjects
    }
}

extension KDTLocationObject: Equatable {
    static func == (lhs: KDTLocationObject, rhs: KDTLocationObject) -> Bool {
        return lhs.cityName == rhs.cityName && lhs.state == rhs.state
    }
}
