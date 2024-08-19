//
//  SwiftUIView.swift
//  Dima Mundo
//
//  Created by Chema Padilla Fdez on 06/08/24.


import SwiftUI
import RiveRuntime

struct InfoView: View {

    @Binding var back: Bool

    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height

    var body: some View {
        ZStack {
            ZStack {

                RiveViewModel(fileName: "info-view", stateMachineName: "Actions", artboardName: "infoView").view()
                    .scaleEffect(1.18)
                
                Button {
                    withAnimation(.linear(duration: 0)) {
                        back = false // Cambia back a false para cerrar
                    }
                } label: {
                    Image("cerrar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UISW * 0.05)
                }.position(x: UISW * 0.79, y: UISH * 0.093)

                ZStack {
                    Text("¡Descubre ")
                        .font(.custom("RifficFree-Bold", size: 28))
                        .foregroundStyle(.black)
                    + Text("DimaMundo")
                        .font(.custom("RifficFree-Bold", size: 28))
                        .foregroundStyle(Color.mollyColor)
                    + Text(", la app que convierte el aprendizaje de las tablas de multiplicar en una aventura emocionante!")
                        .font(.custom("RifficFree-Bold", size: 28))
                        .foregroundStyle(.black)
                }.frame(width: UISW * 0.78)
                .multilineTextAlignment(.center)
                .offset(y: UISH * 0.13)

                ZStack {
                    Text("A través de actividades creativas, los")
                        .font(.custom("RifficFree-Bold", size: 28))
                        .foregroundStyle(.black)
                    + Text(" pequeños ")
                        .font(.custom("RifficFree-Bold", size: 28))
                        .foregroundStyle(Color.Naranja)
                    + Text("exploradores ")
                        .font(.custom("RifficFree-Bold", size: 28))
                        .foregroundStyle(.black)
                    + Text("dominarán las matemáticas ")
                        .font(.custom("RifficFree-Bold", size: 28))
                        .foregroundStyle(Color.Azul)
                    + Text("sin siquiera darse cuenta. ")
                        .font(.custom("RifficFree-Bold", size: 28))
                        .foregroundStyle(.black)
                }.frame(width: UISW * 0.77)
                .multilineTextAlignment(.center)
                .offset(y: UISH * 0.27)

            }.frame(width: UISW * 0.86, height: UISH * 0.8)

        }.ignoresSafeArea()
    }
}

#Preview {
    let back = State(initialValue: false)
    
    return InfoView(back: back.projectedValue)
}

