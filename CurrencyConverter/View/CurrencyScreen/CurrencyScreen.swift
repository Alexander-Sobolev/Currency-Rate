//
//  CurrencyScreen.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import SwiftUI

struct CurrencyScreen: View {
    @State var showSheet     = false
    @StateObject var vm      = CurrencyScreenViewModel()
    @FocusState var focus: Bool
    
    var body: some View {
        VStack {
            Spacer()
            LineGraphView(
                data: vm.graphData,
                profit: true,
                currency: $vm.selectedOptionTarget
            )
            .onTapGesture {
                showSheet.toggle()
            }
            .padding(50)
            .background(.ultraThinMaterial)
            .cornerRadius(25)
            .padding()
            .zIndex(0)
            Spacer()
            VStack {
                VStack {
                    TextField("Enter amount", text: $vm.enteredAmount)
                        .multilineTextAlignment(.center)
                        .tint(Color.white)
                        .keyboardType(.decimalPad)
                        .focused($focus)
                        .padding(.vertical, 5)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                    
                    Text("= \(vm.conversionResult)")
                        .foregroundColor(Color.white)
                }
                
                HStack(spacing: 5) {
                    DropDownView(
                        hint:      "Select",
                        options:    Currency.allCurrencies.map({$0.text}),
                        anchor:    .top,
                        selection: $vm.selectedOptionSource
                    )
                    
                    Image(systemName: "arrow.left.arrow.right")
                        .onTapGesture {
                            let source = vm.selectedOptionSource
                            let target = vm.selectedOptionTarget
                            vm.selectedOptionSource = target
                            vm.selectedOptionTarget = source
                        }
                    
                    DropDownView(
                        hint:      "Select",
                        options:    Currency.allCurrencies.map({$0.text}),
                        anchor:    .top,
                        selection: $vm.selectedOptionTarget
                    )
                }
                .padding()
                
                Button(action: {
                    vm.addTransactionRecord()
                    focus = false
                }, label: {
                    ZStack {
                        Text("Make transaction")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                    }
                })
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
            )
            .padding()
            .zIndex(1)
        }
        .onAppear {
            vm.loadEveryCurrency() {
                vm.fetchDataAndSave()
            }
        }
        
        .onReceive(vm.$selectedOptionSource, perform: { _ in
            vm.fetchDataAndSave()
        })
        
        .onReceive(vm.$selectedOptionTarget, perform: { _ in
            vm.fetchDataAndSave()
        })
      
        .sheet(isPresented: $showSheet, content: {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .opacity(0.5)
                        .onTapGesture {
                            showSheet = false
                    }
                }
                .padding(.horizontal)
                LineGraphView(
                    data: vm.graphData,
                    profit: true,
                    currency: $vm.selectedOptionTarget
                )
                .padding(50)
                .frame(height: 300)
                
                .presentationDetents([.height(350)])
            }
        })
    }
}

#Preview {
    CurrencyScreen()
}
