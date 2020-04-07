//
//  WeatherManager.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/25/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherData)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let baseURL = "https://api.darksky.net/forecast"
    
    func fetchWeather(latitude: Double, longitude: Double) {
        guard var builtURL = URL(string: baseURL) else { return }
        
        // Append API Key
        builtURL.appendPathComponent("83e3034647d9444ddd308d1ba30f44f2")
        
        // Append location
        builtURL.appendPathComponent("\(latitude),\(longitude)")
        
        performRequest(with: builtURL)
    }
    
    func performRequest(with url: URL) {
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                // Handle error
                self.delegate?.didFailWithError(error: error)
                print("\nThere was an error: Performing the weather request in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
                return
            }
            
            if let data = data {
                // parse json
                if let weatherData = self.parseJSON(data) {
                    self.delegate?.didUpdateWeather(self, weather: weatherData)
                }
            }
        }
        
        dataTask.resume()
    }
    
    func parseJSON(_ data: Data) -> WeatherData? {
        
        let decoder = JSONDecoder()
        
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            return weatherData
            
        } catch {
            // Handle Error
            self.delegate?.didFailWithError(error: error)
            print("\nThere was an error: Parsing JSON in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
            return nil
        }
    }
    
    
    
    static func getWeatherIcon(with icon: String) -> String {
        switch icon {
        case Constants.clearDay: return "☀️"
        case Constants.clearNight: return "🌙"
        case Constants.rain: return "🌧"
        case Constants.snow: return "🌨"
        case Constants.sleet: return "🌨"
        case Constants.wind: return "💨"
        case Constants.fog: return "🌫"
        case Constants.cloudy: return "☁️"
        case Constants.partlyCloudyDay: return "⛅️"
        case Constants.partlyCloudyNight: return "🌥"
        default: return "🤷🏼‍♂️"
        }
    }
}
