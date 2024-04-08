//
//  Item.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import SwiftUI

struct Item: Identifiable {
    private(set) var id: UUID = .init()
    var title: String
    var view:  AnyView
    
    init<V: View>(title: String, view: V) {
        self.title = title
        self.view  = AnyView(view)
    }
}
