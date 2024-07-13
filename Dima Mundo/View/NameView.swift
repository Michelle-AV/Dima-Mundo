//
//  NameView.swift
//  Dima Mundo
//
//  Created by Chema Padilla Fdez on 09/06/24.
//

import SwiftUI

struct NameView: View {
    
    @State private var selectedColor: ColorOption = .azulFuerte
    
    @State var positionAzul: CGFloat = UIScreen.main.bounds.width * 0.1
    @State var positionRosa: CGFloat = UIScreen.main.bounds.width * 0.3
    @State var positionAzulFuerte: CGFloat = UIScreen.main.bounds.width * 0.5
    @State var positionNaranja: CGFloat = UIScreen.main.bounds.width * 0.7
    @State var positionMorado: CGFloat = UIScreen.main.bounds.width * 0.9
    
    @State var isTappedAzul: Bool = false
    @State var isTappedRosa: Bool = false
    @State var isTappedAzulFuerte: Bool = true
    @State var isTappedNaranja: Bool = false
    @State var isTappedMorado: Bool = false
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(selectedColor.color)
                .frame(width: UISW, height: UISH)
            
            Fondo()
                .frame(width: UISW, height: UISH)
            
            Circle()
                .foregroundColor(Color.Azul)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 7)
                )
                .frame(width: isTappedAzul ? 120 : 100)
                .position(x: positionAzul, y: UISH * 0.85)
                .padding()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)){
                        selectedColor = .azul
                    }
                }
            
            Circle()
                .foregroundColor(Color.Rosa)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 7)
                )
                .frame(width: isTappedRosa ? 120 : 100)
                .position(x: positionRosa, y: UISH * 0.85)
                .padding()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)){
                        selectedColor = .rosa
                    }
                }
            
            Circle()
                .foregroundColor(Color.AzulFuerte)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 7)
                )
                .frame(width: isTappedAzulFuerte ? 120 : 100)
                .position(x: positionAzulFuerte, y: UISH * 0.85)
                .padding()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)){
                        selectedColor = .azulFuerte
                    }
                }
            
            Circle()
                .foregroundColor(Color.Naranja)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 7)
                )
                .frame(width: isTappedNaranja ? 120 : 100)
                .position(x: positionNaranja, y: UISH * 0.85)
                .padding()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)){
                        selectedColor = .naranja
                    }
                }
            
            Circle()
                .foregroundColor(Color.Morado)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 7)
                )
                .frame(width: isTappedMorado ? 120 : 100)
                .position(x: positionMorado, y: UISH * 0.85)
                .padding()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)){
                        selectedColor = .morado
                    }
                }
            
            if (selectedColor.color == Color.Azul){
                Circle()
                    .fill(.clear)
                    .onAppear{
                        withAnimation (.easeInOut(duration: 0.35)){
                            isTappedAzul = true
                            isTappedAzulFuerte = false
                            isTappedNaranja = false
                            isTappedRosa = false
                            isTappedMorado = false
                            
                            positionAzul = UISW * 0.5
                            positionRosa = UISW * 0.7
                            positionAzulFuerte = UISW * 0.9
                            positionNaranja = UISW * 0.1
                            positionMorado = UISW * 0.3
                        }
                    }
            }
            if (selectedColor.color == Color.Rosa){
                Circle()
                    .fill(.clear)
                    .onAppear{
                        withAnimation (.easeInOut(duration: 0.35)){
                            isTappedAzul = false
                            isTappedAzulFuerte = false
                            isTappedNaranja = false
                            isTappedRosa = true
                            isTappedMorado = false
            
                            positionAzul = UISW * 0.3
                            positionRosa = UISW * 0.5
                            positionAzulFuerte = UISW * 0.7
                            positionNaranja = UISW * 0.9
                            positionMorado = UISW * 0.1
                        }
                    }
            }
            if (selectedColor.color == Color.AzulFuerte){
                Circle()
                    .fill(.clear)
                    .onAppear{
                        withAnimation (.easeInOut(duration: 0.35)){
                            isTappedAzul = false
                            isTappedAzulFuerte = true
                            isTappedNaranja = false
                            isTappedRosa = false
                            isTappedMorado = false
            
                            positionAzul = UISW * 0.1
                            positionRosa = UISW * 0.3
                            positionAzulFuerte = UISW * 0.5
                            positionNaranja = UISW * 0.7
                            positionMorado = UISW * 0.9
                        }
                    }
            }
            if (selectedColor.color == Color.Naranja){
                Circle()
                    .fill(.clear)
                    .onAppear{
                        withAnimation (.easeInOut(duration: 0.35)){
                            isTappedAzul = false
                            isTappedAzulFuerte = false
                            isTappedNaranja = true
                            isTappedRosa = false
                            isTappedMorado = false
            
                            positionAzul = UISW * 0.9
                            positionRosa = UISW * 0.1
                            positionAzulFuerte = UISW * 0.3
                            positionNaranja = UISW * 0.5
                            positionMorado = UISW * 0.7
                        }
                    }
            }
            if (selectedColor.color == Color.Morado){
                Circle()
                    .fill(.clear)
                    .onAppear{
                        withAnimation (.easeInOut(duration: 0.35)){
                            isTappedAzul = false
                            isTappedAzulFuerte = false
                            isTappedNaranja = false
                            isTappedRosa = false
                            isTappedMorado = true
            
                            positionAzul = UISW * 0.7
                            positionRosa = UISW * 0.9
                            positionAzulFuerte = UISW * 0.1
                            positionNaranja = UISW * 0.3
                            positionMorado = UISW * 0.5
                        }
                    }
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    NameView()
}
