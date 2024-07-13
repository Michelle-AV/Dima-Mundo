//
//  MainView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 04/07/24.
//
import SwiftUI

struct MainView: View {
    @State private var showPerfilesView = false
    @State private var backgroundOpacity = 0.0
    @State private var viewOpacity = 0.0

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button("Iniciar") {
                        withAnimation(.easeIn(duration: 0.5)) {
                            backgroundOpacity = 1.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showPerfilesView = true
                            withAnimation(.easeIn(duration: 0.5)) {
                                viewOpacity = 1.0
                            }
                        }
                    }
                    .font(.custom("RifficFree-Bold", size: 30))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    
                    Button("Información") {
                        print("Mostrar información")
                    }
                    .font(.custom("RifficFree-Bold", size: 30))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                }
                Button("< Idioma >") {
                    print("Cambiar idioma")
                }
                .font(.custom("RifficFree-Bold", size: 30))
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
            }


            Color.purple
                .opacity(backgroundOpacity)
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)

            // Muestra PerfilesView encima de todo cuando esté activo
            if showPerfilesView {
                PerfilesView()
                    .opacity(viewOpacity)
                    .transition(.opacity)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
