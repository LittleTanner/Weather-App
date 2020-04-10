//
//  WeatherObject.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/25/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit


class WeatherObject {
    
    var currentTemp: Int
    var currentSummary: String
    var chanceOfRain: Int
    var humidity: Int
    var visibility: Double
    var dailySummary: String
    var icon: String
    
    var hourlyWeather: [HourlyData]
    var dailyWeather: [DailyData]
    
    init(currentTemp: Int, currentSummary: String, chanceOfRain: Int, humidity: Int, visibility: Double, dailySummary: String, icon: String, hourlyWeather: [HourlyData], dailyWeather: [DailyData]) {
        self.currentTemp = currentTemp
        self.currentSummary = currentSummary
        self.chanceOfRain = chanceOfRain
        self.humidity = humidity
        self.visibility = visibility
        self.dailySummary = dailySummary
        self.icon = icon
        self.hourlyWeather = hourlyWeather
        self.dailyWeather = dailyWeather
    }
    
    
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

extension WeatherObject: Equatable {
    static func == (lhs: WeatherObject, rhs: WeatherObject) -> Bool {
        return lhs.currentTemp == rhs.currentTemp
            && lhs.currentSummary == rhs.currentSummary
            && lhs.chanceOfRain == rhs.chanceOfRain
            && lhs.humidity == rhs.humidity
            && lhs.visibility == rhs.visibility
            && lhs.dailySummary == rhs.dailySummary
            && lhs.icon == rhs.icon
            && lhs.hourlyWeather == rhs.hourlyWeather
            && lhs.dailyWeather == rhs.dailyWeather
    }
}
