//
//  Int+Ext.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/22/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import Foundation

extension Int {
    
    func convertDateFromIntToString(_ dateAsInt: Int) -> String {
        let unixTimestampAsDouble = Double(dateAsInt)
        let date = Date(timeIntervalSince1970: unixTimestampAsDouble)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date)
    }
}
