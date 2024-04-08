//
//  CurrencyScreenViewModel.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import Foundation

class CurrencyScreenViewModel: ObservableObject {
    let parser = CBRParser()
    @Published var selectedOptionSource: Currency = .USD
    @Published var selectedOptionTarget: Currency = .RUB
    @Published var graphData: [Double] = []
    @Published var enteredAmount = "1"
    
    func fetchDataAndSave() {
        restoreFromDB()
        
        parser.fetchTodayCurrencies { currentCurrencyRecords in
            if let currentCurrencyRecords {
                for currencyRecord in currentCurrencyRecords {
                    if let currency = Currency.allCurrencies.first(where: {$0.rawValue == currencyRecord.charCode}),
                       let value = Double(currencyRecord.value.replacingOccurrences(of: ",", with: ".")) {
                        let todayData = AppData.shared.currentRates.value
                        todayData?.values[currency] = value
                        AppData.shared.currentRates.value = todayData
                    }
                }
            }
        }
        
        parser.fetchCurrencyForLastTwoWeeks(sourceCurrency: selectedOptionSource, targetCurrency: selectedOptionTarget) { records in
            if let records {
                let historicalRates = AppData.shared.historicalRates.value
                historicalRates?.values[self.selectedOptionSource] = records
                AppData.shared.historicalRates.value = historicalRates
            }
        }
    }
    
    
    func loadEveryCurrency(complition: @escaping () -> Void) { // Optional method to cache all data
        for currentCurrency in Currency.allCurrencies.filter({$0 != .RUB}) {
            for targetCurrency in Currency.allCurrencies.filter({$0 != .RUB}) {
                parser.fetchCurrencyForLastTwoWeeks(sourceCurrency: currentCurrency, targetCurrency: targetCurrency) { records in
                    if let records {
                        let historicalRates = AppData.shared.historicalRates.value
                        historicalRates?.values[currentCurrency] = records
                        AppData.shared.historicalRates.value = historicalRates
                        complition()
                    }
                }
            }
        }
    }
        
    func restoreFromDB() {
        
        let records = AppData.shared.historicalRates.value?.values[self.selectedOptionSource]
        var rublesConvertedResult: [CurrencyRecord] = []
        if let records {
            
            for item in records.enumerated() {
                let resultItem = item.element
                rublesConvertedResult.append(.init(
                    date: resultItem.date,
                    nominal: resultItem.nominal,
                    value: String(CurrencyManager.convertCurrency(sourceCurrency: selectedOptionSource, targetCurrency: selectedOptionTarget, amount: (Double(resultItem.value.replacingOccurrences(of: ",", with: ".")) ?? 1), index: item.offset) ?? 0),
                    unitRate: resultItem.unitRate,
                    charCode: resultItem.charCode,
                    name: resultItem.name
                    )
                )
            }
        }
        
        self.graphData = rublesConvertedResult.map({Double($0.value.replacingOccurrences(of: ",", with: ".")) ?? 0.0})
        if self.selectedOptionSource == self.selectedOptionTarget {
            self.graphData = [1.0, 1.0, 1.0, 1.0]
        }
    }
    
    var conversionResult: Double {
        CurrencyManager.convertCurrency(sourceCurrency: selectedOptionSource, targetCurrency: selectedOptionTarget, amount: Double(enteredAmount) ?? 0.0) ?? 0.0
    }
    
    func addTransactionRecord() {
        if let amount = Double(enteredAmount) {
            let record = TransactionRecord(amount: amount, sourceCurrency: selectedOptionSource, targetCurrency: selectedOptionTarget, convertedResult: conversionResult, date: Date())
            var values = AppData.shared.transactionHistory.value?.values ?? []
            values.append(record)
            AppData.shared.transactionHistory.value = .init(values: values)
        }
    }
}
