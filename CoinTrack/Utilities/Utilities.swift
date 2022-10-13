//
//  Utilities.swift
//  CoinTrack
//
//  Created by Sandip Rudani on 2022-10-08.
//

import Foundation

extension Date {
    
    init(stringValue: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: stringValue) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
    
}

extension Double {
    
    /// Converts a Double into a Currency with 2 decimal places
    private func currencyFormatter(decimal: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = decimal
        return formatter
    }
    
    /// Converts a Double into a Currency as a String with 2 decimal places
    func asCurrencyWithNumberOfDecimals(_ decimalNumber: Int) -> String {
        let number = NSNumber(value: self)
        return currencyFormatter(decimal: decimalNumber).string(from: number) ?? "$0.00"
    }

    
    /// Converts a Double into string representation
    var asNumberString: String {
        return String(format: "%.2f", self)
    }
    
    /// Converts a Double into string representation with percent symbol
    var asPercentString: String {
        return asNumberString + "%"
    }
    
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    var monetaryDescription: String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString

        default:
            return "\(sign)\(self)"
        }
    }
}
