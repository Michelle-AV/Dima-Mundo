//
//  MainView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 04/07/24.
//
import SwiftUI

struct MainView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var perfilesViewModel: PerfilesViewModel
    @State private var showPerfilesView = false
    @State private var showInfoView = false 
    @State private var backgroundOpacity = 0.0
    @State private var viewOpacity = 0.0

    var body: some View {
        ZStack {
            Image("inicio-fondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Text("Dima Mundo")
                .font(.custom("RifficFree-Bold", size: 135))
                .foregroundColor(.white)
                .position(x:appData.UISW * 0.5, y:appData.UISH * 0.155)

            Button{
                withAnimation(.easeInOut(duration: 0.1)) {
                    appData.sound.toggle()
                }
            } label: {
                Image(appData.sound ? "sound" : "mute")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                   
            }.position(x: appData.UISW * 0.94, y: appData.UISH * 0.09)
            
            VStack {
                
                HStack (spacing: 20){
                    
                    Color.VerdeBtn
                        .frame(width: 200, height: 60, alignment: .center)
                        .cornerRadius(15)
                        .overlay{
                            Text("Iniciar")
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.5)) {
                                backgroundOpacity = 1.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeIn(duration: 0.5)) {
                                    showPerfilesView = true
                                    viewOpacity = 1.0
                                    SoundManager.instance.stopDialog()
                                }
                            }
                        }
                    
                    Color.VerdeBtn
                        .frame(width: 200, height: 60, alignment: .center)
                        .cornerRadius(15)
                        .overlay{
                            Text("Información")
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            withAnimation(.bouncy(duration: 0.3)) {
                                showInfoView = true
                            }
                        }
                    
                }
                
                Button("< Español >") {
                    print("Cambiar idioma")
                }
                .font(.custom("RifficFree-Bold", size: 30))
                .foregroundColor(.white)
                .padding()
                .background(Color.VerdeClaroBtn)
                .cornerRadius(10)
                .offset(y: 14)
            }
            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.85)

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
                    .transition(.move(edge: .top))
                    .zIndex(1)
                    .position(x: appData.UISW * 0.5, y: appData.UISH * 0.5)
            }
        }
        .ignoresSafeArea()
        .onAppear{
            if appData.sound {
                SoundManager.instance.playSound(sound: .MainTheme)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    if appData.sound {
                        SoundManager.instance.playDialogES(sound: .Bienvenido, loop: false)
                    }
                }
            }
        }
        .onChange(of: appData.sound) { newValue in
            if newValue {
                if appData.sound{
                    SoundManager.instance.resumeActiveSound()
                }
            } else {
                SoundManager.instance.pauseActiveSound()
                SoundManager.instance.stopDialog()
            }
        }
    }
}

#Preview{
    MainView()
        .environmentObject(AppData())
        .environmentObject(PerfilesViewModel())
}
