//
//  ConvertedHistory.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import Foundation


class TransactionHistory: DatabaseObject {
    static var dataBaseKey: String = "TransactionHistory"
    var values: [TransactionRecord] {
        didSet {
            AppData.shared.transactionHistory.objectWillChange.send()
        }
    }
    
    init(values: [TransactionRecord]) {
        self.values = values
    }

}
