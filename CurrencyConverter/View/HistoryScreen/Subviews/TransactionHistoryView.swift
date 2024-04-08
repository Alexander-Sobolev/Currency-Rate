//
//  TransactionHistoryView.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 27.03.2024.
//

import SwiftUI

struct TransactionHistoryView: View {
    var record: TransactionRecord
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                
                Text(record.date.formattedDayMonthYear())
                Spacer()
                Text(record.date.formattedTime())
            }
            VStack(spacing: 10) {
                Text(record.sourceCurrency.text) +
                Text(record.amount.removeZerosFromEnd())
                Image(systemName: "arrow.up.arrow.down")
                Text(record.targetCurrency.text) +
                Text(record.convertedResult.removeZerosFromEnd())
            }
            .padding()
            
            Text(record.id.uuidString)
                .font(.system(size: 12))
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(25)
        .padding()
    }
}

#Preview {
    HistoryScreen()
}
