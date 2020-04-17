//
//  WeatherData.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/25/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let currently: Currently?
    let hourly: Hourly?
    let daily: Daily?
}

struct Currently: Codable {
    let time: Int
    let summary: String
    let icon: String
    let precipProbability: Double
    let temperature: Double
    let apparentTemperature: Double
}

struct Hourly: Codable {
    let data: [HourlyData]
}

struct HourlyData: Codable, Equatable {
    let time: Int
    let icon: String
    let precipProbability: Double
    let temperature: Double
}

struct Daily: Codable {
    let data: [DailyData]
}

struct DailyData: Codable, Equatable {
    let time: Int
    let icon: String
    let precipProbability: Double
    let temperatureHigh: Double
    let temperatureLow: Double
}
