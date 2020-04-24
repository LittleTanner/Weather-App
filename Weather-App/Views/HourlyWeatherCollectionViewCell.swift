//
//  HourlyWeatherCollectionViewCell.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/31/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        cellBackgroundView.backgroundColor = .collectionCellBackground
        cellBackgroundView.layer.cornerRadius = StyleGuide.cornerRadius
    }

    func configure(with city: KDTLocationObject, indexPath: IndexPath) {
        if let indexForObject = city.weatherObject?.hourlyWeather[indexPath.row],
            let timezone = city.weatherObject?.timezone {
            let rainAsDouble = indexForObject.precipProbability * 100
            let rainAsInt = Int(rainAsDouble)
            
            timeLabel.text = indexForObject.time.convertToHourOfDay(withTimezone: timezone)
            weatherIcon.image = WeatherObject.getWeatherIcon(with: indexForObject.icon)
            tempLabel.text = "\(Int(indexForObject.temperature))°"
            rainLabel.text = "\(rainAsInt)%"
        }
    }
}
