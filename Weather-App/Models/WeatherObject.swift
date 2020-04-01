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
        case "clear-day":           return UIImage(named: "clear-day")!
        case "clear-night":         return UIImage(named: "clear-night")!
        case "rain":                return UIImage(named: "rain")!
        case "snow":                return UIImage(named: "snow")!
        case "sleet":               return UIImage(named: "sleet")!
        case "wind":                return UIImage(named: "wind")!
        case "fog":                 return UIImage(named: "fog")!
        case "cloudy":              return UIImage(named: "cloudy")!
        case "partly-cloudy-day":   return UIImage(named: "partly-cloudy-day")!
        case "partly-cloudy-night": return UIImage(named: "partly-cloudy-night")!
        default:                    return UIImage(named: "default")!
        }
    }
}
