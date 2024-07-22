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
                        print("Mostrar información")
                    }
                    .font(.custom("RifficFree-Bold", size: 30))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.VerdeBtn)
                    .cornerRadius(10)
                }
                Button("< Idioma >") {
                    print("Cambiar idioma")
                }
                .font(.custom("RifficFree-Bold", size: 30))
                .foregroundColor(.white)
                .padding()
                .background(Color.VerdeClaroBtn)
                .cornerRadius(10)
            }
           .position(x:appData.UISW * 0.5,y:appData.UISH * 0.83)
 
            Color.MoradoFondo
                .opacity(backgroundOpacity)
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)

            if showPerfilesView {
                PerfilesView()
                    .opacity(viewOpacity)
                    .transition(.opacity)
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
