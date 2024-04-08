//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .preferredColorScheme(.dark)
                .onAppear {
                    for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
                        print("\(key) = \(value) \n")
                }
            }
        }
    }
}
