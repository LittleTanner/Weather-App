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
    @IBOutlet weak var weatherIconLabel: UILabel!
    @IBOutlet weak var tempHighLabel: UILabel!
    @IBOutlet weak var tempLowLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
