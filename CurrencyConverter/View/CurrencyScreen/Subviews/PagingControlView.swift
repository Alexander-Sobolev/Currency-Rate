//
//  PagingControl.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import SwiftUI

struct PagingControlView: UIViewRepresentable {
    var numberOfPages: Int
    var activePage:    Int
    var onPageChange: (Int) -> ()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onPageChange: onPageChange)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        let view = UIPageControl()
        view.currentPage     = activePage
        view.numberOfPages   = numberOfPages
        view.backgroundStyle = .prominent
        view.currentPageIndicatorTintColor = UIColor(Color.primary)
        view.pageIndicatorTintColor = UIColor.placeholderText
        view.addTarget(context.coordinator, 
                       action: #selector(Coordinator.onPageUpdate(control:)),
                       for: .valueChanged)
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        /// Updating Outside Event Changes
        uiView.numberOfPages = numberOfPages
        uiView.currentPage   = activePage
    }
    
    class Coordinator: NSObject {
        var onPageChange: (Int) -> ()
        init(onPageChange: @escaping (Int) -> Void) {
            self.onPageChange = onPageChange
        }
        
        @objc
        func onPageUpdate(control: UIPageControl) {
            onPageChange(control.currentPage)
        }
    }
}
