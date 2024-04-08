//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import Foundation

enum Currency: String, Codable {
    static var dataBaseKey: String = "Currency"
    
    case RUB, USD, EUR, GBP, CHF, CNY
    
    var text: String {
        switch self {
        case .RUB:
            return "RUB 🇷🇺"
        case .USD:
            return "USD 🇺🇸"
        case .EUR:
            return "EUR 🇪🇺"
        case .GBP:
            return "GBP 🇬🇧"
        case .CHF:
            return "CHF 🇨🇭"
        case .CNY:
            return "CNY 🇨🇳"
        }
    }
    
    static var allCurrencies: [Currency] {
        return [.RUB, .USD, .EUR, .GBP, .CHF, .CNY]
    }
    
    var cbrID: String {
        switch self {
        case .RUB:
            "-----" // не используется
        case .USD:
            "R01235"
        case .EUR:
            "R01239"
        case .GBP:
            "R01035"
        case .CHF:
            "R01775"
        case .CNY:
            "R01375"
        }
    }
    
    init?(fromText text: String) {
        switch text {
        case "RUB 🇷🇺":
            self = .RUB
        case "USD 🇺🇸":
            self = .USD
        case "EUR 🇪🇺":
            self = .EUR
        case "GBP 🇬🇧":
            self = .GBP
        case "CHF 🇨🇭":
            self = .CHF
        case "CNY 🇨🇳":
            self = .CNY
        default:
            return nil
        }
    }
}
