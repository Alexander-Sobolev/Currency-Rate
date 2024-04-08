//
//  HistoricalRate.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import Foundation

class HistoricalRates: DatabaseObject {
    static var dataBaseKey: String = "HistoricalRates"
    var values:  [Currency: [CurrencyRecord]]
    
    init(values: [Currency : [CurrencyRecord]]) {
        self.values = values
    }
    
   
}
