//
//  CurrentRates.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import Foundation

class CurrentRates: DatabaseObject {
    static var dataBaseKey: String = "CurrentRates"
    var values:  [Currency: Double]
    
    init(fromResponse: [Currency: Double]) {
        values = fromResponse
    }
    
   
}
