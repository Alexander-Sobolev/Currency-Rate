//
//  CurrencyManager.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import Foundation

class CurrencyManager {
    
    static func convertCurrency(sourceCurrency: Currency, 
                                targetCurrency: Currency,
                                amount: Double) -> Double? {
        
        addRubleIfNeeded()
        
        guard let sourceRateToRUB = AppData.shared.currentRates.value?.values[sourceCurrency] else {
            return nil
        }
        
        guard let targetRateToRUB = AppData.shared.currentRates.value?.values[targetCurrency] else {
            return nil
        }
        
        let amountInRUB = amount * sourceRateToRUB
        
        let convertedAmount = amountInRUB / targetRateToRUB
        
        return convertedAmount
    }

    
    static func convertCurrency(sourceCurrency: Currency,
                                targetCurrency: Currency,
                                amount: Double, 
                                index: Int) -> Double? {
        
        addRubleIfNeeded()
        
        guard let source = Double(AppData.shared.historicalRates.value?.values[sourceCurrency]?[safe: index]?.unitRate.replacingOccurrences(of: ",", with: ".") ?? "1") else {
            return nil
        }
        
        guard let target = Double(AppData.shared.historicalRates.value?.values[targetCurrency]?[safe: index]?.unitRate.replacingOccurrences(of: ",", with: ".") ?? "1") else {
            return nil
        }
        
        if sourceCurrency == .RUB {
            return 1 / target
        }
        
        if targetCurrency == .RUB {
            return source
        }
        
        return source / target
    }
    
    
    static private func addRubleIfNeeded() {
        guard (AppData.shared.currentRates.value?.values[Currency.RUB]) != nil else {
            AppData.shared.currentRates.value?.values[Currency.RUB] = 1.0
            return
        }
    }
    
    //MARK: - Replaced because of quota limit on freecurrencyapi.com
    //    func saveExchangeRates() {
    //        for currency in Currency.allCurrencies {
    //            networkManager.fetchExchangeRates(baseCurrency: currency) { result in
    //                do {
    //                    AppData.shared.currentRates.value = .init(fromResponse: try result.get())
    //
    //                } catch {
    //                    print(error.localizedDescription)
    //                }
    //            }
    //        }
    //
    //    }
    //
    //
    //    func saveHistoricalRates(baseCurrency: Currency, targetCurrency: Currency) {
    //        networkManager.fetchHistoricalExchangeRates(baseCurrency: baseCurrency, targetCurrency: targetCurrency) { result in
    //            do {
    //                AppData.shared.historicalRates.value = .init(.init(fromResponse: ["\(baseCurrency.rawValue)/\(targetCurrency.rawValue)": try result.get()]))
    //            } catch {
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }
    
//    static func convertCurrency(sourceCurrency: Currency, targetCurrency: Currency, amount: Double) -> Double? {
//        guard let sourceRate = AppData.shared.currentRates.value?.values[sourceCurrency],
//              let targetRate = AppData.shared.currentRates.value?.values[targetCurrency] else {
//            return nil
//        }
//        
//        let baseAmount = amount / sourceRate
//        let convertedAmount = baseAmount * targetRate
//        return convertedAmount
//    }
    
}
