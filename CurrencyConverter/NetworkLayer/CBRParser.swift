//
//  TestParser.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import Foundation
import Alamofire
import SWXMLHash

// Parser for central bank of Russia
class CBRParser {
    
    func fetchCurrencyForLastTwoWeeks(sourceCurrency: Currency, 
                                      targetCurrency: Currency,
                                      completion: @escaping ([CurrencyRecord]?) -> Void ) {
        let endDate  = Date()
        let calendar = Calendar.current
        guard let startDate = calendar.date(byAdding: .day, value: -14, to: endDate) else { return }
        fetchHistoryData(startDate: startDate.toCBRFormat(), endDate: endDate.toCBRFormat(), currencyID: sourceCurrency != .RUB ? sourceCurrency.cbrID : targetCurrency.cbrID) { result in
            
            if let result, !result.isEmpty {
                var rublesConvertedResult: [CurrencyRecord] = []
                for item in result.enumerated() {
                    let resultItem = item.element
                    rublesConvertedResult.append(.init(
                        date: resultItem.date,
                        nominal: resultItem.nominal,
                        value: String(CurrencyManager.convertCurrency(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency, amount: (Double(resultItem.value.replacingOccurrences(of: ",", with: ".")) ?? 1), index: item.offset) ?? 0),
                        unitRate: resultItem.unitRate,
                        charCode: resultItem.charCode,
                        name: resultItem.name
                        )
                    )
                }
                completion(rublesConvertedResult)
            }
        }
    }
    
    func fetchTodayCurrencies(completion: @escaping (([CurrencyRecord]?) -> Void)) {
        let date      = Date().toCBRFormat()
        let urlString = "https://www.cbr.ru/scripts/XML_daily.asp?date_req=\(date)"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                let xml = XMLHash.parse(data)
                let currencyRecords = self.parseDailyCurrencyRecords(xml: xml)
                completion(currencyRecords)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func parseDailyCurrencyRecords(xml: XMLIndexer) -> [CurrencyRecord] {
        var records = [CurrencyRecord]()
        for valute in xml["ValCurs"]["Valute"].all {
            let charCode = valute["CharCode"].element?.text ?? ""
            let nominal  = Int(valute["Nominal"].element?.text ?? "0") ?? 0
            let name     = valute["Name"].element?.text ?? ""
            let value    = valute["Value"].element?.text ?? ""
            let currencyRecord = CurrencyRecord(
                date: xml["ValCurs"].element?.attribute(by: "Date")?.text ?? "",
                nominal:  nominal,
                value:    value,
                unitRate: value,
                charCode: charCode,
                name:     name)
            records.append(currencyRecord)
        }
        return records
    }
    
    
    
    private func fetchHistoryData(startDate:  String,
                                  endDate:    String,
                                  currencyID: String,
                                  completion: @escaping ([CurrencyRecord]?) -> Void) {
        let urlString = "https://www.cbr.ru/scripts/XML_dynamic.asp?date_req1=\(startDate)&date_req2=\(endDate)&VAL_NM_RQ=\(currencyID)"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                let xml = XMLHash.parse(data)
                let currencyRecords = self.parseCurrencyRecords(xml: xml)
                completion(currencyRecords)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    private func parseCurrencyRecords(xml: XMLIndexer) -> [CurrencyRecord] {
        var records      = [CurrencyRecord]()
        for record in xml["ValCurs"]["Record"].all {
            let date     = record.element?.attribute(by: "Date")?.text ?? ""
            let nominal  = Int(record["Nominal"].element?.text ?? "0") ?? 0
            let value    = record["Value"].element?.text ?? ""
            let unitRate = record["VunitRate"].element?.text ?? ""
            let currencyRecord = CurrencyRecord(date:     date,
                                                nominal:  nominal,
                                                value:    value,
                                                unitRate: unitRate,
                                                charCode: nil,
                                                name:     nil)
            records.append(currencyRecord)
        }
        return records
    }
}

struct CurrencyRecord: Codable {
    let date:     String
    let nominal:  Int
    let value:    String
    let unitRate: String
    let charCode: String?
    let name:     String?
}
