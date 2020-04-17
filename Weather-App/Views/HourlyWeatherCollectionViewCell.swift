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
//        layer.cornerRadius = 15
//        layer.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 0.5)
        cellBackgroundView.layer.cornerRadius = 10
    }

    
    func configure(with city: KDTLocationObject, indexPath: IndexPath) {
        if let indexForObject = city.weatherObject?.hourlyWeather[indexPath.row] {
            let rainAsDouble = indexForObject.precipProbability * 100
            let rainAsInt = Int(rainAsDouble)
            
            let unixTimestampAsDouble = Double(indexForObject.time)
            let date = Date(timeIntervalSince1970: unixTimestampAsDouble)
            let dateFormatter = DateFormatter()
            let timezone = TimeZone.current.abbreviation() ?? "PST"
            dateFormatter.timeZone = TimeZone(abbreviation: timezone)
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "h a"
            let time = dateFormatter.string(from: date)
            
            timeLabel.text = time
            weatherIcon.image = WeatherObject.getWeatherIcon(with: indexForObject.icon)
            tempLabel.text = "\(Int(indexForObject.temperature))°"
            rainLabel.text = "\(rainAsInt)%"
        }
    }
    
}
