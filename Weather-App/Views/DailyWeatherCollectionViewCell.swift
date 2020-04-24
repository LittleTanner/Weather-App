//
//  DailyWeatherCollectionViewCell.swift
//  Weather-App
//
//  Created by Kevin Tanner on 3/31/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

class DailyWeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var tempHighLabel: UILabel!
    @IBOutlet weak var tempLowLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        cellBackgroundView.backgroundColor = .collectionCellBackground
        cellBackgroundView.layer.cornerRadius = StyleGuide.cornerRadius
    }

    func configure(with city: KDTLocationObject, indexPath: IndexPath) {
        if let indexForObject = city.weatherObject?.dailyWeather[indexPath.row],
            let timezone = city.weatherObject?.timezone {
            
            let rainAsDouble = indexForObject.precipProbability * 100
            let rainAsInt = Int(rainAsDouble)
            
            dayLabel.text = indexForObject.time.convertToDayAbbreviation(withTimezone: timezone)
            weatherIconImageView.image = WeatherObject.getWeatherIcon(with: indexForObject.icon)
            rainLabel.text = "\(rainAsInt)%"
            tempHighLabel.text = "\(Int(indexForObject.temperatureHigh))°"
            tempLowLabel.text = "\(Int(indexForObject.temperatureLow))°"
        }
    }
    
}
