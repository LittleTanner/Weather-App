//
//  WeatherObject.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/25/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit


class WeatherObject: Codable {
    
    var currentTemp: Int
    var currentFeelsLikeTemp: Int
    var dailyTempHigh: Int
    var dailyTempLow: Int
    var currentSummary: String
    var icon: String
    var timezone: String
    
    var hourlyWeather: [HourlyData]
    var dailyWeather: [DailyData]
    
    init(currentTemp: Int, currentFeelsLikeTemp: Int, dailyTempHigh: Int, dailyTempLow: Int, currentSummary: String, icon: String, timezone: String, hourlyWeather: [HourlyData], dailyWeather: [DailyData]) {
        self.currentTemp = currentTemp
        self.currentFeelsLikeTemp = currentFeelsLikeTemp
        self.dailyTempHigh = dailyTempHigh
        self.dailyTempLow = dailyTempLow
        self.currentSummary = currentSummary
        self.icon = icon
        self.timezone = timezone
        self.hourlyWeather = hourlyWeather
        self.dailyWeather = dailyWeather
    }
    
    // MARK: - Helper Methods
    
    func getBackgroundImage(for icon: String) -> UIImage {
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
    
    static func getWeatherIcon(with icon: String) -> UIImage {
        switch icon {
        case Constants.clearDay:            return UIImage(named: Constants.clearDayIcon)!
        case Constants.clearNight:          return UIImage(named: Constants.clearNightIcon)!
        case Constants.rain:                return UIImage(named: Constants.rainIcon)!
        case Constants.snow:                return UIImage(named: Constants.snowIcon)!
        case Constants.sleet:               return UIImage(named: Constants.sleetIcon)!
        case Constants.wind:                return UIImage(named: Constants.windIcon)!
        case Constants.fog:                 return UIImage(named: Constants.fogIcon)!
        case Constants.cloudy:              return UIImage(named: Constants.cloudyIcon)!
        case Constants.partlyCloudyDay:     return UIImage(named: Constants.partlyCloudyDayIcon)!
        case Constants.partlyCloudyNight:   return UIImage(named: Constants.partlyCloudyNightIcon)!
        default:                            return UIImage(named: Constants.cloudyIcon)!
        }
    }
    
}

// MARK: - Equatable

extension WeatherObject: Equatable {
    static func == (lhs: WeatherObject, rhs: WeatherObject) -> Bool {
        return lhs.currentTemp == rhs.currentTemp
            && lhs.currentSummary == rhs.currentSummary
            && lhs.icon == rhs.icon
            && lhs.hourlyWeather == rhs.hourlyWeather
            && lhs.dailyWeather == rhs.dailyWeather
    }
}
