//
//  DateExtension.swift
//  SoleApp
//
//  Created by SUN on 2023/03/22.
//

import Foundation

extension Date {
    public func toString(format: String, locale: String? = nil, timeZone: String? = nil) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale     = locale == nil ? Locale(identifier: "ko_KR") : Locale(identifier: locale!)
        dateFormatter.timeZone   = timeZone == nil ? nil : TimeZone(abbreviation: timeZone!.uppercased())
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
