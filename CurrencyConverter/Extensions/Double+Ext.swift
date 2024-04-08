//
//  Double+Ext.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import Foundation

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 // Максимальное количество цифр после запятой в Double
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    func convertToCurrency(currency: Currency) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency.rawValue
        return formatter.string(from: .init(value: self)) ?? ""
    }
}
