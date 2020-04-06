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
    @IBOutlet weak var weatherIcon: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
        layer.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 0.5)
    }

}
