//
//  MainView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 04/07/24.
//
import SwiftUI

struct MainView: View {
    @EnvironmentObject var appData: AppData
    @State private var showPerfilesView = false
    @State private var showInfoView = false // Estado para mostrar InfoView
    @State private var backgroundOpacity = 0.0
    @State private var viewOpacity = 0.0

    var body: some View {
        ZStack {
            Image("inicio-fondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                HStack {
                    Button("Iniciar") {
                        withAnimation(.easeIn(duration: 0.5)) {
                            backgroundOpacity = 1.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeIn(duration: 0.5)) {
                                showPerfilesView = true
                                viewOpacity = 1.0
                            }
                        }
                    }
                    .font(.custom("RifficFree-Bold", size: 30))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.VerdeBtn)
                    .cornerRadius(10)
                    
                    Button("Información") {
                        withAnimation(.bouncy(duration: 0.3)) {
                            showInfoView = true // Mostrar InfoView con animación
                        }
                    }
                    .font(.custom("RifficFree-Bold", size: 30))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.VerdeBtn)
                    .cornerRadius(10)
                }
                Button("< Español [MX] >") {
                    print("Cambiar idioma")
                }
                .font(.custom("RifficFree-Bold", size: 30))
                .foregroundColor(.white)
                .padding()
                .background(Color.VerdeClaroBtn)
                .cornerRadius(10)
            }
            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.83)

            Color.MoradoFondo
                .opacity(backgroundOpacity)
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)

            if showPerfilesView {
                PerfilesView(onHome: {
                    // Handle returning to MainView
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showPerfilesView = false
                        backgroundOpacity = 0.0
                    }
                })
                .opacity(viewOpacity)
                .transition(.opacity)
            }

            // Mostrar InfoView con una transición y fondo negro
            if showInfoView {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .transition(.opacity)

                InfoView(back: $showInfoView)
                    .transition(.move(edge: .top)) // Transición desde arriba
                    .zIndex(1) // Asegura que la vista esté al frente
            }
        }
        .ignoresSafeArea()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppData())
    }
}
