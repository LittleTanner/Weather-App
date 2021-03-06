//
//  Constants.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/27/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import Foundation

struct Constants {
    
    // Storyboard IDs
    static let mainStoryboard = "Main"
    
    // View Controller IDs
    static let weatherPageViewControllerID = "WeatherPageViewControllerID"
    static let locationViewControllerID = "LocationViewControllerID"
    static let onboardingWelcomeViewControllerID = "OnboardingWelcomeViewController"
    static let onboardingAllowLocationViewControllerID = "OnboardingAllowLocationViewController"
    static let onboardingAddLocationViewControllerID = "OnboardingAddLocationViewController"
    static let locationsNavigationControllerID = "LocationsNavigationController"
    
    // Table View Cells
    static let locationTableViewCell = "LocationTableViewCell"
    
    // Table View Cell Identifiers
    static let addressCellIdentifier = "addressCell"
    static let locationCellIdentifier = "locationCell"
    
    // Collection View Cells
    static let hourlyWeatherCell = "HourlyWeatherCollectionViewCell"
    static let dailyWeatherCell = "DailyWeatherCollectionViewCell"
    
    // Collection View Cell Identifiers
    static let hourlyWeatherCellIdentifier = "hourlyWeatherCellXIB"
    static let dailyWeatherCellIdentifier = "dailyWeatherCellXIB"
    
    // Segue Identifiers
    static let segueToSearchForLocation = "toSearchForLocation"
    static let segueToLocationsNavigationController = "toLocationsNavigationController"
    
    // Weather Background Images
    static let clearDay = "clear-day"
    static let clearNight = "clear-night"
    static let rain = "rain"
    static let snow = "snow"
    static let sleet = "sleet"
    static let wind = "wind"
    static let fog = "fog"
    static let cloudy = "cloudy"
    static let partlyCloudyDay = "partly-cloudy-day"
    static let partlyCloudyNight = "partly-cloudy-night"
    static let defaultImage = "default"

    // Weather Icons
    static let clearDayIcon = "ClearDayIcon"
    static let clearNightIcon = "ClearNightIcon"
    static let rainIcon = "RainIcon"
    static let snowIcon = "SnowIcon"
    static let sleetIcon = "SleetIcon"
    static let windIcon = "WindIcon"
    static let fogIcon = "FogIcon"
    static let cloudyIcon = "CloudyIcon"
    static let partlyCloudyDayIcon = "PartlyCloudyDayIcon"
    static let partlyCloudyNightIcon = "PartlyCloudyNightIcon"
    static let defaultImageIcon = "CloudyIcon"
    
    // Animation Image Prefix
    static let cloudRefreshPrefix = "CloudRefresh"
    
    // Animation Image Total
    static let cloudRefreshImageCount = 10
}
