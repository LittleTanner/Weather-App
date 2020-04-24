//
//  Int+Ext.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/22/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import Foundation

extension Int {
    
    func convertToDayAbbreviation(withTimezone timezone: String) -> String {
        let unixTimestampAsDouble = Double(self)
        let date = Date(timeIntervalSince1970: unixTimestampAsDouble)
        DateHelper.shared.dateFormatter.timeZone = TimeZone(identifier: timezone)
        DateHelper.shared.dateFormatter.dateFormat = "EEE"
        return DateHelper.shared.dateFormatter.string(from: date)
    }
    
    func convertToHourOfDay(withTimezone timezone: String) -> String {
        let unixTimestampAsDouble = Double(self)
        let date = Date(timeIntervalSince1970: unixTimestampAsDouble)
        DateHelper.shared.dateFormatter.timeZone = TimeZone(identifier: timezone)
        DateHelper.shared.dateFormatter.dateFormat = "h a"
        return DateHelper.shared.dateFormatter.string(from: date)
    }
}
