//
//  LocationTableViewCell.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/8/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureHighLowLabel: UILabel!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var weatherBackgroundView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        weatherBackgroundView.layer.borderWidth = 3
        weatherBackgroundView.layer.borderColor = UIColor.blueBackground.cgColor
    }
    
}
