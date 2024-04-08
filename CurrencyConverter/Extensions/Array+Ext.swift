//
//  Array+Ext.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
