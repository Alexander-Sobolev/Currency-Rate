//
//  LineGraph.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import SwiftUI

struct LineGraphView: View {
    var data:  [Double]
    var profit: Bool = false
    
    @State var currentPlot            = ""
    @State var offset: CGSize         = .zero
    @State var showPlot               = false
    @State var translation: CGFloat   = 0
    @GestureState var isDrag: Bool    = false
    @State var graphProgress: CGFloat = 0
    @Binding var currency: Currency
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            
            let maxPoint = (data.max() ?? 0)
            let minPoint = data.min() ?? 0
            
            let points = data.enumerated().compactMap { item -> CGPoint in
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                
                let pathHeight = progress * (height - 50)
                let pathWidth = width * CGFloat(item.offset)
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            ZStack{
                AnimatedGraphPath(progress: graphProgress, points: points)
                    .fill(
                        LinearGradient(colors: [
                            profit ? Color.green : Color.red,
                            profit ? Color.green : Color.red,
                        ], startPoint: .leading, endPoint: .trailing)
                    )
            }
            .overlay(
                VStack(spacing: 0){
                    
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical,6)
                        .frame(width: 100)
                        .background(Color("Gradient1"),in: Capsule())
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1,height: 40)
                        .padding(.top)
                    
                    Circle()
                        .fill(Color("Gradient1"))
                        .frame(width: 22, height: 22)
                        .overlay(
                            
                            Circle()
                                .fill(.white)
                                .frame(width: 10, height: 10)
                        )
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1,height: 50)
                }
                    .frame(width: 80,height: 170)
                    .offset(y: 70)
                    .offset(offset)
                    .opacity(showPlot ? 1 : 0),
                
                alignment: .bottomLeading
            )
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                
                withAnimation{showPlot = true}
                
                let translation = value.location.x
                
                let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)
                
                if !data.isEmpty {
                    currentPlot = data[index].convertToCurrency(currency: currency)
                    self.translation = translation
                    
                    offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
                }
                
            }).onEnded({ value in
                
                withAnimation{showPlot = false}
                
            }).updating($isDrag, body: { value, out, _ in
                out = true
            }))
        }
        .background(
            
            VStack(alignment: .leading) {
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5, content: {
                    Text("Last 7 Days")
                        .font(.caption)
                        .foregroundColor(.gray)
                })
                .offset(y: 25)
            }
                .frame(maxWidth: .infinity,alignment: .leading)
        )
        .padding(.horizontal,10)
        .onChange(of: isDrag, initial: true) { newValue, _  in
            if !isDrag{showPlot = false}
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)){
                    graphProgress = 1
                }
            }
        }
        .onChange(of: data, initial: true) { newValue, _ in
            graphProgress = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)){
                    graphProgress = 1
                }
            }
        }
    }
}
