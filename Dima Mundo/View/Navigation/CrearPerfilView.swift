//
//  CrearPerfilView.swift
//  Dima Mundo
//
//  Created by Chema Padilla & Pedro Prado on 02/07/24.
//
import SwiftUI
import RiveRuntime

struct CrearPerfilView: View {
    @EnvironmentObject var appData: AppData
    @ObservedObject var viewModel = PerfilesViewModel()
    @StateObject private var riveModel = RiveModel()
    @State private var selectedAvatarIndex: Int = 2
    @State private var selectedColor: ColorOption = .azul
    @State private var userName: String = ""
    @State private var textWidth: CGFloat = 100
    @State private var buttonVisible: Bool = true
    @State private var keyboardVisible: Bool = false
//    @State var sound: Bool = true
    @State private var textFieldFrame: CGRect = .zero

    var onSave: () -> Void
    var onCancel: () -> Void

    let initialPositions: [CGFloat]
    @State var positions: [CGFloat]
    @State var isSelected: [Bool] = [false, false, true, false, false]
    let riveFileNames = ["molly", "monin", "melody", "pablo", "jack3"]

    init(onSave: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.onSave = onSave
        self.onCancel = onCancel
        initialPositions = [
            UIScreen.main.bounds.width * 0.1,
            UIScreen.main.bounds.width * 0.3,
            UIScreen.main.bounds.width * 0.5,
            UIScreen.main.bounds.width * 0.7,
            UIScreen.main.bounds.width * 0.9
        ]
        _positions = State(initialValue: initialPositions)
    }

    var body: some View {
        ZStack {
            Color(selectedColor.color)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut, value: selectedColor)
            FondoMP()
                .frame(width: appData.UISW, height: appData.UISH)
            
            Button{
                withAnimation(.easeInOut(duration: 0.1)) {
                    appData.isTuto = true
                }
            } label: {
                Image("tutorialIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                   
            }.position(x: appData.UISW * 0.87, y: appData.UISH * 0.09)
            
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
            
                Button(action: onCancel) {
                    Image("back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .padding()
                        .foregroundColor(.white)
                }
                .position(x:appData.UISW * 0.06, y:appData.UISH * 0.1)
            
            ZStack {
                Text("Ingresa tu nombre")
                    .font(.custom("RifficFree-Bold", size: 65))
                    .foregroundColor(.white)
                    .position(x:appData.UISW * 0.5, y:appData.UISH * 0.1)

                TextField("Escribe acá", text: $userName)
                    .disabled(true)
                    .onChange(of: userName) { newValue in
                        DispatchQueue.main.async {
                            userName = newValue.capitalizingFirstLetterAfterSpace()
                        }
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
                            appData.FlagTuto = 1
                        }
                    }
                    .position(x:appData.UISW * 0.5, y:appData.UISH * 0.25)
            }
            
            Image("podioXL")
                .resizable()
                .scaledToFit()
                .frame(width: 265)
                .position(x: appData.UISW * 0.5, y: appData.UISH * 0.65 + 314)
        
            ForEach(0..<5, id: \.self) { index in
                Image("avatar\(index + 1)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: isSelected[index] ? 120 : 100, height: isSelected[index] ? 100 : 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 7))
                    .position(x: positions[index], y: appData.UISH * 0.85)
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
                ZStack {
                    ZStack {
                        Button(action: {
                            saveProfile()
                            onSave()  // Llamar a la función onSave al guardar el perfil
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
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.85)
                        .opacity(buttonVisible ? 1 : 0)
                        .animation(.easeOut(duration: 0.35), value: buttonVisible)
                        
                        Text("Agregar")
                            .font(.custom("RifficFree-Bold", size: 25))
                            .foregroundColor(.white)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.939)
                    }
                    .opacity(buttonVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.35), value: buttonVisible)
                    
                    RiveViewModel(fileName: riveModel.fileName, stateMachineName: "Actions", artboardName: "podiumAB").view()
                        .id(riveModel.fileName)
//                        .frame(width: 600 * 0.75, height: 900 * 0.75)
                        .scaleEffect(0.6)
                        .allowsHitTesting(false)
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.589)
                        
                }
            }
            
            if appData.isTuto {
                TutorialView(viewType: .crearPerfil(self.userName))
            }
            
            if keyboardVisible {
                CustomKeyboardView(text: $userName, keyboardVisible: $keyboardVisible)
                    .scaleEffect(1.2)
                    .position(x: appData.UISW * 0.5, y: appData.UISH * 0.75)
            }
        }
        .ignoresSafeArea()
        .onAppear{
            if viewModel.perfiles.count == 0 {
                appData.isTuto = true
            }
            appData.FlagTuto = 0
        }
    }

    func selectAvatar(at index: Int) {
        selectedAvatarIndex = index
        riveModel.fileName = riveFileNames[index]
        buttonVisible = false
        for i in 0..<5 {
            isSelected[i] = i == index
        }
        adjustPositions(selectedIndex: index)
        updateColor(for: index)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            buttonVisible = true
        }
    }

    func adjustPositions(selectedIndex: Int) {
        var newPositions = initialPositions
        newPositions[selectedIndex] = appData.UISW * 0.5
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

#Preview {
    CrearPerfilView(onSave: {}, onCancel: {})
        .environmentObject(AppData())
        .environmentObject(PerfilesViewModel())
}
