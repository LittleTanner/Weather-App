//
//  WeatherManager.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/25/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherData)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let baseURL = "https://api.darksky.net/forecast"
    
    
    func getWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherObject?) -> Void) {
        guard var builtURL = URL(string: baseURL) else { return }
        
        // Append API Key
        builtURL.appendPathComponent("83e3034647d9444ddd308d1ba30f44f2")
        
        // Append location
        builtURL.appendPathComponent("\(latitude),\(longitude)")
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: builtURL) { (data, response, error) in
            if let error = error {
                // Handle error
                print("\nThere was an error: Performing the weather request in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
                completion(nil)
                return
            }
            
            if let data = data {
                // parse json
                let decoder = JSONDecoder()
                
                do {
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    
                    guard let currentWeather = weatherData.currently,
                        let dailyWeather = weatherData.daily,
                        let dailySummary = dailyWeather.data.first?.summary,
                        let hourlyWeather = weatherData.hourly?.data,
                        let dailyWeatherData = weatherData.daily?.data else { return }
                    
                    let currentTemp = Int(currentWeather.temperature)
                    let currentSummary = currentWeather.summary
                    let chanceOfRainAsDouble = currentWeather.precipProbability * 100.0
                    let chanceOfRain = Int(chanceOfRainAsDouble)
                    let humidityAsDouble = currentWeather.humidity * 100.0
                    let humidity = Int(humidityAsDouble)
                    let visibility = currentWeather.visibility
                    let icon = currentWeather.icon
                    
                    let weatherObject = WeatherObject(currentTemp: currentTemp, currentSummary: currentSummary, chanceOfRain: chanceOfRain, humidity: humidity, visibility: visibility, dailySummary: dailySummary, icon: icon, hourlyWeather: hourlyWeather, dailyWeather: dailyWeatherData)
                    
                    completion(weatherObject)
                    return
                    
                } catch {
                    // Handle Error
                    print("\nThere was an error: Parsing JSON in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
                    completion(nil)
                    return
                }
            }
        }
        
        dataTask.resume()
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
