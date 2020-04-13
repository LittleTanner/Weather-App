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
        // Initialization code
        cellBackgroundView.layer.cornerRadius = 10
    }

}
