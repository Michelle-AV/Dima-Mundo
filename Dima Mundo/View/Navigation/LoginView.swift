//
//  LoginView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 16/08/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var isPresented: Bool
    @Binding var isLoggedIn: Bool // Estado de sesión iniciada
    @EnvironmentObject var appData: AppData
    
    let username = "UNACH" // Usuario predefinido
    let correctPin = "12345" // PIN correcto para validación
    @State private var pin: [String] = ["", "", "", "", ""] // PIN de 5 dígitos
    @State private var currentPinIndex = 0 // Índice actual del PIN
    @State private var isKeyboardVisible = false // Controla la visibilidad del teclado
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.white)
                .frame(width: appData.UISW * 0.45, height: isKeyboardVisible ? appData.UISH * 0.9 : appData.UISH * 0.8)
            
            VStack(spacing: 40) {
                Text("¡Bienvenid@, \(username)!")
                    .font(.custom("RifficFree-Bold", size: 40))
                    .foregroundColor(.skinMonin)
                    .padding(.top, 20)
                
                Image("avatar2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: appData.UISW * 0.2)
                
                HStack(spacing: 15) {
                    ForEach(0..<5) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.CelesteBG)
                                .frame(width: appData.UISW * 0.05, height: appData.UISH * 0.08)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isKeyboardVisible.toggle() // Mostrar teclado al tocar un cuadro
                                    }
                                }
                            
                            Text(pin[index].isEmpty ? "" : "•")
                                .font(.custom("RifficFree-Bold", size: 30))
                                .foregroundColor(.CelesteLbl)
                        }
                    }
                }
                .padding(.vertical, 20)
                
                if isKeyboardVisible {
                    CustomNumericKeyboard { key in
                        handleKeyPress(key)
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                
                Button(action: {
                    let enteredPin = pin.joined()
                    if enteredPin == correctPin {
                        withAnimation {
                            isLoggedIn = true // Cambia el estado a sesión iniciada
                            isPresented = false // Cierra el LoginView
                        }
                    } else {
                        print("PIN incorrecto")
                    }
                }) {
                    Text("Iniciar Sesión")
                        .font(.custom("RifficFree-Bold", size: 25))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: appData.UISW * 0.2, height: appData.UISH * 0.075)
                        .background(Color.VerdeBtnDash)
                        .cornerRadius(15)
                }
            }
            .padding()
            .frame(width: appData.UISW * 0.45, height: appData.UISH * 0.8)
        }
    }
    
    private func handleKeyPress(_ key: String) {
        withAnimation(.easeInOut(duration: 0.3)) {
            if key == "x" {
                if currentPinIndex > 0 {
                    currentPinIndex -= 1
                    pin[currentPinIndex] = ""
                }
            } else if key == "OK" {
                print("PIN ingresado: \(pin.joined())")
                isKeyboardVisible = false // Ocultar teclado después de presionar OK
            } else if currentPinIndex < 5 {
                pin[currentPinIndex] = key
                currentPinIndex += 1
                
                if currentPinIndex == 5 {
                    isKeyboardVisible = false
                }
            }
        }
    }
}

#Preview {
    LoginView(isPresented: .constant(true), isLoggedIn: .constant(false))
        .environmentObject(AppData())
}
