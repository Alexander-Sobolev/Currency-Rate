//
//  AppData.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import Foundation

class AppData {
    static var shared      = AppData()
    var currentRates       = DBStatable<CurrentRates>(defaultValueIfNil: .init(fromResponse: [:]))
    var historicalRates    = DBStatable<HistoricalRates>(defaultValueIfNil: .init(values: [:]))
    var transactionHistory = DBStatable<TransactionHistory>(defaultValueIfNil: .init(values: []))
}
