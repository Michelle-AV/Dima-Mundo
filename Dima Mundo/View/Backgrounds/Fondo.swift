//
//  ContentView.swift
//  Dima Mundo
//
//  Created by Chema Padilla Fdez on 07/06/24.
//

import SwiftUI

struct Fondo: View {
    
    @State var animate: Bool = false
    
    @State var offset1X: CGFloat = .zero
    @State var offset1Y: CGFloat = .zero
    @State var position1X: CGFloat = 560
    @State var position1Y: CGFloat = 0

    @State var offset2X: CGFloat = .zero
    @State var offset2Y: CGFloat = .zero
    @State var position2X: CGFloat = -240
    @State var position2Y: CGFloat = 400
    
    @State var offset3X: CGFloat = .zero
    @State var offset3Y: CGFloat = .zero
    @State var position3X: CGFloat = 300
    @State var position3Y: CGFloat = 450
    
    @State var offset4X: CGFloat = .zero
    @State var offset4Y: CGFloat = .zero
    @State var position4X: CGFloat = 1250
    @State var position4Y: CGFloat = 0
    
    @State var offset5X: CGFloat = .zero
    @State var offset5Y: CGFloat = .zero
    @State var position5X: CGFloat = 1250
    @State var position5Y: CGFloat = 0
    
    @State var offset6X: CGFloat = .zero
    @State var offset6Y: CGFloat = .zero
    @State var position6X: CGFloat = -60
    @State var position6Y: CGFloat = 940
    
    @State var offset7X: CGFloat = .zero
    @State var offset7Y: CGFloat = .zero
    @State var position7X: CGFloat = 740
    @State var position7Y: CGFloat = 520
    
    @State var offset8X: CGFloat = .zero
    @State var offset8Y: CGFloat = .zero
    @State var position8X: CGFloat = -900
    @State var position8Y: CGFloat = 1340
    
    @State var offset9X: CGFloat = .zero
    @State var offset9Y: CGFloat = .zero
    @State var position9X: CGFloat = 1570
    @State var position9Y: CGFloat = 420
    
    @State var offset10X: CGFloat = .zero
    @State var offset10Y: CGFloat = .zero
    @State var position10X: CGFloat = 620
    @State var position10Y: CGFloat = 890
    
    @State var rapidezX: CGFloat = 0.5
    @State var rapidezY: CGFloat = 0.25
    
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Image("patron")
                .resizable()
                .scaledToFit()
                .frame(width: 820)
                .opacity(0.19)
                .rotationEffect(.degrees(-25))
                .position(x: position1X, y: position1Y)
                .offset(x: offset1X, y: -offset1Y)
            
            Image("patron")
                .resizable()
                .scaledToFit()
                .frame(width: 820)
                .opacity(0.19)
                .rotationEffect(.degrees(-25))
                .position(x: position2X, y: position2Y)
                .offset(x: offset2X, y: -offset2Y)
            
            Image("patron")
                .resizable()
                .scaledToFit()
                .frame(width: 820)
                .opacity(0.19)
                .rotationEffect(.degrees(-25))
                .position(x: position6X, y: position6Y)
                .offset(x: offset6X, y: -offset6Y)

            Image("patron")
                .resizable()
                .scaledToFit()
                .frame(width: 820)
                .opacity(0.19)
                .rotationEffect(.degrees(-25))
                .position(x: position7X, y: position7Y)
                .offset(x: offset7X, y: -offset7Y)

            Image("patron")
                .resizable()
                .scaledToFit()
                .frame(width: 820)
                .opacity(0.19)
                .rotationEffect(.degrees(-25))
                .position(x: position8X, y: position8Y)
                .offset(x: offset8X, y: -offset8Y)

            Image("patron2")
                .resizable()
                .scaledToFit()
                .frame(width: 950)
                .opacity(0.19)
                .rotationEffect(.degrees(-25))
                .position(x: position4X, y: position4Y)
                .offset(x: offset3X, y: -offset3Y)
            
            Image("patron2")
                .resizable()
                .scaledToFit()
                .frame(width: 950)
                .opacity(0.19)
                .rotationEffect(.degrees(-25))
                .position(x: position3X, y: position3Y)
                .offset(x: offset4X, y: -offset4Y)
            
            Image("patron2")
                .resizable()
                .scaledToFit()
                .frame(width: 950)
                .opacity(0.19)
                .rotationEffect(.degrees(-25))
                .position(x: -640, y: 900)
                .offset(x: offset5X, y: -offset5Y)
            
            Image("patron2")
                .resizable()
                .scaledToFit()
                .frame(width: 950)
                .opacity(0.19)
                .rotationEffect(.degrees(-25))
                .position(x: position10X, y: position10Y)
                .offset(x: offset10X, y: -offset10Y)
            
            Image("patron2")
                .resizable()
                .scaledToFit()
                .frame(width: 950)
                .opacity(0.19)
                .rotationEffect(.degrees(-25))
                .position(x: position9X, y: position9Y)
                .offset(x: offset9X, y: -offset9Y)
            
        }.ignoresSafeArea()
            .onAppear{
                animate = true
            }
            .animation(Animation.easeInOut(duration: 0.2).repeatForever(autoreverses: true), value: animate)
            .onReceive(timer) { _ in
                
                //Fila 1
                if (position2X + offset2X + 150 == position1X) {
                    offset1X = -980
                    offset1Y = -490
                } else {
                    offset1X += rapidezX
                    offset1Y += rapidezY
                }
                if (offset2X == 1400) {
                    offset2X = -250
                    offset2Y = -125
                } else {
                    offset2X += rapidezX
                    offset2Y += rapidezY
                }
                
                //Fila 2
                if (offset3X == 1100) {
                    offset3X = -1750
                    offset3Y = -820
                } else {
                    offset3X += rapidezX
                    offset3Y += rapidezY
                }
                if (offset4X == 2000) {
                    offset4X = -830
                    offset4Y = -370
                } else {
                    offset4X += rapidezX
                    offset4Y += rapidezY
                }
                if (offset5X == 2300) {
                    offset5X = -530
                    offset5Y = -240
                } else {
                    offset5X += rapidezX
                    offset5Y += rapidezY
                }
                
                //Fila 3
                if (offset7X == 1400) {
                    offset7X = -1070
                    offset7Y = -520
                } else {
                    offset7X += rapidezX
                    offset7Y += rapidezY
                }
                if (offset6X == 2200) {
                    offset6X = -300
                    offset6Y = -100
                } else {
                    offset6X += rapidezX
                    offset6Y += rapidezY
                }
                if (offset8X == 2700) {
                    offset8X = 220
                    offset8Y = 130
                } else {
                    offset8X += rapidezX
                    offset8Y += rapidezY
                }
                
                if (offset9X == 450) {
                    offset9X = -1420
                    offset9Y = -700
                } else {
                    offset9X += rapidezX
                    offset9Y += rapidezY
                }
                if (offset10X == 1350) {
                    offset10X = -500
                    offset10Y = -250
                } else {
                    offset10X += rapidezX
                    offset10Y += rapidezY
                }
            }
    }
}

#Preview {
    Fondo()
}
