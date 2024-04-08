//
//  CurrencyTextField.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import SwiftUI

struct CurrencyTextField: View {
    @Binding var enteredAmount: String
    @State private var textFieldWidth: CGFloat = 2
    @FocusState  var isTextFieldFocused: Bool 
    var body: some View {
       
            TextField("", text: $enteredAmount)
                .multilineTextAlignment(.center)
                .tint(Color.white)
                .keyboardType(.decimalPad)
                
          
        
        .frame(width: self.textFieldWidth)
        .background(GeometryReader { geometryProxy in
            Color.clear.onAppear {
                self.textFieldWidth = self.widthForContent(geometryProxy.size.width)
            }
        })
            .onChange(of: enteredAmount, initial: true) { _, _ in
                self.textFieldWidth = self.widthForContent()
            }
            .focused($isTextFieldFocused)
    }
}

extension CurrencyTextField {
    private func widthForContent(_ availableWidth: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGFloat {
        let text = enteredAmount.isEmpty ? " " : enteredAmount
        let font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return min(max(size.width + 20, 50), availableWidth)
    }
}
