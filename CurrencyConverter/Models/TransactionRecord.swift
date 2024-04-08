//
//  TransactionRecord.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import Foundation


struct TransactionRecord: Hashable, Codable {
    
    var id:              UUID = UUID()
    var amount:          Double
    var sourceCurrency:  Currency
    var targetCurrency:  Currency
    var convertedResult: Double
    var date:            Date
}
