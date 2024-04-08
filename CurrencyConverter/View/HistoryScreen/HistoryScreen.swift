//
//  HistoryScreen.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import SwiftUI

struct HistoryScreen: View {
    @ObservedObject var transactions = AppData.shared.transactionHistory
    @State private var searchText    = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 5) {
                    if let savedTransactions = transactions.value?.values {
                        if filteredTransactions(savedTransactions).isEmpty {
                            GeometryReader { geometry in
                                Text(transactions.value?.values.isEmpty ?? true 
                                     ? "There's no saved transactions"
                                     : "Searching transaction not found")
                                    .position(x: geometry.size.width  / 2,
                                              y: geometry.size.height / 2)
                                    .padding(.top)
                            }
                            
                        } else {
                            ForEach(filteredTransactions(savedTransactions), id: \.self) { record in
                                TransactionHistoryView(record: record)
                            }
                        }
                    } else {
                        GeometryReader { geometry in
                            Text(transactions.value?.values.isEmpty ?? true 
                                 ? "There's no saved transactions"
                                 : "Searching transaction not found")
                                .position(x: geometry.size.width  / 2,
                                          y: geometry.size.height / 2)
                                .padding(.top)
                        }
                    }
                }
            }
            .searchable(text: $searchText, 
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search transactions")
            .background(.ultraThinMaterial.opacity(0.7))
        }
        .cornerRadius(25)
        .padding(.top, 10)
        .tint(.white)
    }
}

extension HistoryScreen {
    private func filteredTransactions(_ transactions: [TransactionRecord]) -> [TransactionRecord] {
        if searchText.isEmpty {
            return Array(transactions)
        } else {
            return transactions.filter { record in
                record.id.uuidString.lowercased().contains(searchText.lowercased()) ||
                record.sourceCurrency.text.lowercased().contains(searchText.lowercased()) ||
                record.targetCurrency.text.lowercased().contains(searchText.lowercased()) ||
                record.date.formattedDayMonthYear().lowercased().contains(searchText.lowercased()) ||
                record.date.formattedTime().lowercased().contains(searchText.lowercased()) ||
                String(record.convertedResult).replacingOccurrences(of: ",", with: ".") .lowercased().contains(searchText.lowercased().replacingOccurrences(of: ",", with: "."))
            }
        }
    }
}
