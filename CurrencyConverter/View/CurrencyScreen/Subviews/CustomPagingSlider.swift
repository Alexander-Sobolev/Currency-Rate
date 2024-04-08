//
//  CustomPagingSlider.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import SwiftUI

struct CustomPagingSlider<Content: View, TitleContent: View, Item: RandomAccessCollection>: View where Item: MutableCollection, Item.Element: Identifiable {
    var showsIndicator: ScrollIndicatorVisibility = .hidden
    var showPagingControl: Bool        = true
    var disablePagingInteraction: Bool = false
    var titleScrollSpeed: CGFloat      = 0.6
    var pagingControlSpacing: CGFloat  = 20
    var spacing: CGFloat               = 10
    
    @Binding var data: Item
    @ViewBuilder var content: (Binding<Item.Element>) -> Content
    @ViewBuilder var titleContent: (Binding<Item.Element>) -> TitleContent
    @State private var activeID: UUID?
    var body: some View {
            VStack(spacing: pagingControlSpacing) {
                ScrollView(.horizontal) {
                    HStack(spacing: spacing) {
                        ForEach($data) { item in
                            VStack(spacing: 0) {
                                titleContent(item)
                                    .frame(maxWidth: .infinity)
                                    .visualEffect { content, geometryProxy in
                                        content
                                            .offset(x: scrollOffset(geometryProxy))
                                    }
                                content(item)
                            }
                            .containerRelativeFrame(.horizontal)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(showsIndicator)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $activeID)
                
                if showPagingControl {
                    PagingControlView(numberOfPages: data.count, activePage: activePage) { value in
                        if let index = value as? Item.Index, data.indices.contains(index) {
                            if let id = data[index].id as? UUID {
                                withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                                    activeID = id
                            }
                        }
                    }
                }
                .disabled(disablePagingInteraction)
            }
        }
    }
}

extension CustomPagingSlider {
    var activePage: Int {
        if let index = data.firstIndex(where: { $0.id as? UUID == activeID }) as? Int {
            return index
        }
        return 0
    }
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.bounds(of: .scrollView)?.minX ?? 0
        
        return -minX * min(titleScrollSpeed, 1.0)
    }
}
