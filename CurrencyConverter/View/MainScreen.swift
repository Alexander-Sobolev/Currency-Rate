//
//  MainScreen.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import SwiftUI

struct MainScreen: View {
    
    @State private var items: [Item] = [
        .init(title: "Currency", view: CurrencyScreen()),
        .init(title: "Transaction History",  view: HistoryScreen())
    ]
    
    @State private var showPagingControl: Bool        = true
    @State private var disablePagingInteraction: Bool = false
    @State private var pagingSpacing: CGFloat         = 20
    @State private var titleScrollSpeed: CGFloat      = 0.9
    @State private var stretchContent: Bool           = true
    var body: some View {
        
        VStack {
            CustomPagingSlider(
                showPagingControl: showPagingControl,
                disablePagingInteraction: disablePagingInteraction,
                titleScrollSpeed: titleScrollSpeed,
                pagingControlSpacing: pagingSpacing,
                data: $items
            ) { $item in
                item.view
            } titleContent: { $item in
                    Text(item.title)
                        .font(.largeTitle.bold())
            }
        }
    }
}

#Preview {
    MainScreen()
}
