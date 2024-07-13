//
//  CrearPerfilView.swift
//  Dima Mundo
//
//  Created by Chema Padilla & Pedro Prado on 02/07/24.
//

import SwiftUI

struct CrearPerfilView: View {
    
    @State private var selectedAvatarIndex: Int = 2  // Índice inicial para el avatar seleccionado
    @State private var selectedColor: ColorOption = .azul  // Color inicial asociado al índice central
    @State private var userName: String = ""
    @State private var textWidth: CGFloat = 100 // Ancho inicial mínimo
    @State private var buttonVisible: Bool = true
    @State private var keyboardVisible: Bool = false

    let initialPositions: [CGFloat] = [
        UIScreen.main.bounds.width * 0.1,
        UIScreen.main.bounds.width * 0.3,
        UIScreen.main.bounds.width * 0.5,
        UIScreen.main.bounds.width * 0.7,
        UIScreen.main.bounds.width * 0.9
    ]

    @State var positions: [CGFloat]
    @State var isSelected: [Bool] = [false, false, true, false, false]

    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height

    init() {
        _positions = State(initialValue: initialPositions)
    }

    var body: some View {
        ZStack {
            Color(selectedColor.color)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut.speed(2), value: selectedColor)
            Fondo()
                .frame(width: UISW, height: UISH)
            
            VStack {
                Text("Ingresa tu nombre")
                    .font(.custom("RifficFree-Bold", size: 65))
                    .foregroundColor(.white)
                    .padding(.top, 55)
                
                TextField("Escribe acá", text: $userName)
                    .disabled(true) // Esto desactiva el teclado nativo.
                    .onChange(of: userName) { newValue in
                        userName = newValue.capitalizingFirstLetterAfterSpace()
                    }
                    .font(.custom("RifficFree-Bold", size: 45))
                    .multilineTextAlignment(.center)
                    .autocapitalization(.words)
                    .padding()
                    .disableAutocorrection(true)
                    .background(Color.white)
                    .cornerRadius(25)
                    .frame(width: max(450, textWidth))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            keyboardVisible = true
                        }
                    }


                
                Spacer()
            }

            Image("podio")
                .resizable()
                .scaledToFit()
                .frame(width: 265)
                .position(x: UISW * 0.5, y: UISH * 0.865)
            
            ForEach(0..<5, id: \.self) { index in
                Image("avatar\(index + 1)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: isSelected[index] ? 120 : 100, height: isSelected[index] ? 100 : 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 7))
                    .position(x: positions[index], y: UISH * 0.85)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            selectAvatar(at: index)
                        }
                        withAnimation(.smooth(duration: 0)) {
                            buttonVisible = false
                        }
                    }
            }
            
            if isSelected[selectedAvatarIndex] {
                VStack {
                    Button(action: {
                        saveProfile()
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .bold()
                            .frame(width: 45)
                            .padding(25)
                            .background(Circle().fill(selectedColor.color))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .position(x: UISW * 0.5, y: UISH * 0.85)
                    .opacity(buttonVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.35), value: buttonVisible)
                    
                Text("Agregar")//Esto me deja con dudas
                        .font(.custom("RifficFree-Bold", size: 25))
                        .foregroundColor(.white)
                        .padding(.top, -50)
                    
                }
                .opacity(buttonVisible ? 1 : 0)
                .animation(.easeOut(duration: 0.35), value: buttonVisible)
            }
            
            if keyboardVisible {
                
                CustomKeyboardView(text: $userName, keyboardVisible: $keyboardVisible)
                    .position(x: UISW * 0.5, y: UISH * 0.72)
                    .scaleEffect(1.2)
            }
        Image("avatares-medidas")
                .resizable()
                .scaledToFit()
                .scaleEffect(1)
                .opacity(0)
        }
        .ignoresSafeArea()
    }

    
    func selectAvatar(at index: Int) {
        buttonVisible = false  // Ocultar el botón inmediatamente
        for i in 0..<5 {
            isSelected[i] = i == index
        }
        selectedAvatarIndex = index
        adjustPositions(selectedIndex: index)
        updateColor(for: index)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {  // Volver a mostrar el botón después de 0.4 segundos
            buttonVisible = true
        }
    }

    func adjustPositions(selectedIndex: Int) {
        var newPositions = initialPositions
        newPositions[selectedIndex] = UISW * 0.5
        newPositions[2] = initialPositions[selectedIndex]
        for i in 0..<5 {
            if i != selectedIndex && i != 2 {
                newPositions[i] = initialPositions[i]
            }
        }
        positions = newPositions
    }

    func updateColor(for index: Int) {
        switch index {
        case 0: selectedColor = .rosa
        case 1: selectedColor = .azulFuerte
        case 2: selectedColor = .azul
        case 3: selectedColor = .naranja
        case 4: selectedColor = .morado
        default: break
        }
    }

    func saveProfile() {
        let avatarName = "avatar\(selectedAvatarIndex + 1)"
        DataManager.shared.addPerfil(nombre: userName, avatarNombre: avatarName)
        print("Perfil guardado: \(userName) con avatar \(avatarName)")
    }
}

extension String {
    func capitalizingFirstLetterAfterSpace() -> String {
        var result = ""
        var capitalizeNext = true

        for character in self {
            if character == " " {
                result.append(character)
                capitalizeNext = true
            } else if capitalizeNext {
                result.append(character.uppercased())
                capitalizeNext = false
            } else {
                result.append(character)
            }
        }
        return result
    }
}

#Preview{
        CrearPerfilView()
}
