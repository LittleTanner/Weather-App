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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 15
        layer.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 0.5)
    }

}
