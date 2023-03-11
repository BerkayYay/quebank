//
//  Date+Utils.swift
//  Quebank
//
//  Created by Berkay YAY on 2.03.2023.
//

import Foundation

extension Date {
    static var quebankDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter
    }
    
    var dayMonthYearString: String {
        let dateFormatter = Date.quebankDateFormatter
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter.string(from: self)
    }
}
