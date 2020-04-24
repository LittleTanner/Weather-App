//
//  WeatherNetworkManager.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/25/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

struct WeatherNetworkManager {
    
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
                        let hourlyWeather = weatherData.hourly?.data,
                        let dailyWeatherData = weatherData.daily?.data,
                        let dailyTempHighAsDouble = dailyWeather.data.first?.temperatureHigh,
                        let dailyTempLowAsDouble = dailyWeather.data.first?.temperatureLow else { return }
                    
                    let currentTemp = Int(currentWeather.temperature)
                    let currentSummary = currentWeather.summary
                    let icon = currentWeather.icon
                    let currentFeelsLikeTemp = Int(currentWeather.apparentTemperature)
                    let dailyTempHigh = Int(dailyTempHighAsDouble)
                    let dailyTempLow = Int(dailyTempLowAsDouble)
                    
                    let weatherObject = WeatherObject(currentTemp: currentTemp, currentFeelsLikeTemp: currentFeelsLikeTemp, dailyTempHigh: dailyTempHigh, dailyTempLow: dailyTempLow, currentSummary: currentSummary, icon: icon, timezone: weatherData.timezone, hourlyWeather: hourlyWeather, dailyWeather: dailyWeatherData)
                    
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
}
