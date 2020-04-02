//
//  WeatherObject.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/25/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit


struct WeatherObject {
    
    let currentTemp: Int
    let currentSummary: String
    let chanceOfRain: Int
    let humidity: Int
    let visibility: Double
    let dailySummary: String
    let icon: String
    
    let hourlyWeather: [HourlyData]
    let dailyWeather: [DailyData]
    
    func getImageForCurrent(for icon: String) -> UIImage {
        switch icon {
        case Constants.clearDay:            return UIImage(named: Constants.clearDay)!
        case Constants.clearNight:          return UIImage(named: Constants.clearNight)!
        case Constants.rain:                return UIImage(named: Constants.rain)!
        case Constants.snow:                return UIImage(named: Constants.snow)!
        case Constants.sleet:               return UIImage(named: Constants.sleet)!
        case Constants.wind:                return UIImage(named: Constants.wind)!
        case Constants.fog:                 return UIImage(named: Constants.fog)!
        case Constants.cloudy:              return UIImage(named: Constants.cloudy)!
        case Constants.partlyCloudyDay:     return UIImage(named: Constants.partlyCloudyDay)!
        case Constants.partlyCloudyNight:   return UIImage(named: Constants.partlyCloudyNight)!
        default:                            return UIImage(named: Constants.defaultImage)!
        }
    }
}
