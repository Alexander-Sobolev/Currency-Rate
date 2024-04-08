//
//  Date+Ext.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import Foundation

extension Date {
    func toCBRFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
    
    func formattedDayMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func formattedTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
