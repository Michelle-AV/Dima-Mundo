import SwiftUI
import RiveRuntime

struct RetoView: View {
    
    @Binding var back: Bool
    
    @EnvironmentObject var appData: AppData
    @ObservedObject var viewModel = PerfilesViewModel()
    @State var isTapped: Bool = false
    @State private var inputNumbers: [String] = ["", "", ""]
    @State private var selectedInputIndex: Int? = nil
    @State private var resultMessage: String = ""
    @State var round: Int = 1
    @State private var randomNumbers: [Int] = [
        Int.random(in: 2...9),
        Int.random(in: 100...999),
        Int.random(in: 2...9),
        Int.random(in: 100...999),
        Int.random(in: 2...9),
        Int.random(in: 100...999)
    ]
    @State private var userAnswers: [Int] = []
    @State private var showPopup: Bool = false
    @State private var operationResults: [(Int, Int, Int)] = [] // Nueva variable que almacena las operaciones
    @State private var expectedResults: [Int] = []  // Nueva variable que almacena los resultados correctos
    @State private var results: [Bool] = [Bool](repeating: false, count: 9)
    @State private var showResults: Bool = false
    @State private var correctCount: Int = 0  // Count of correct answers
    var selectedAvatar: String
    var selectedPerfil: Perfil
    
    var incrementExercises: () -> Void

    let positions: [CGFloat] = [0.07, 0.147, 0.224, 0.301, 0.378, 0.455, 0.531, 0.608, 0.685, 0.764, 0.842]
    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ""]

    var body: some View {
        ZStack {
            Image("retof")
                .resizable()
                .scaledToFill()
                .frame(width: appData.UISW * 1, height: appData.UISH * 1)
            
            // Mostrar operaciones
            ForEach(0..<3) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.VerdePiz)
                        .frame(width: 110, height: 110)
                    
                    Text("\(randomNumbers[index * 2])")
                        .font(.custom("RifficFree-Bold", size: 65))
                        .foregroundColor(.white)
                }.position(x: appData.UISW * 0.32, y: appData.UISH * CGFloat(0.2 + (Double(index) * 0.18)))
                
                ImageSetView()/// Operadores matemáticos
                
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.VerdePiz)
                        .frame(width: 110, height: 110)
                    
                    Text("\(randomNumbers[index * 2 + 1])")
                        .font(.custom("RifficFree-Bold", size: 50))
                        .foregroundColor(.white)
                }.position(x: appData.UISW * 0.48, y: appData.UISH * CGFloat(0.2 + (Double(index) * 0.18)))
                
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.VerdePiz)
                        .frame(width: 140, height: 110)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selectedInputIndex == index ? Color.white : Color.clear, lineWidth: 7)
                        )
                    
                    Text(inputNumbers[index])
                        .font(.custom("RifficFree-Bold", size: 50))
                        .foregroundColor(.white)
                }
                .position(x: appData.UISW * 0.66, y: appData.UISH * CGFloat(0.2 + (Double(index) * 0.18)))
                .onTapGesture {
                    selectedInputIndex = index
                }
            }
            
            // Usamos el RiveManager compartido para la animación
            RiveManager.shared.riveModel.view()
                .scaleEffect(0.6)
                .allowsHitTesting(false)
                .position(x: appData.UISW * 0.14, y: appData.UISH * 0.57)
            
            // Teclado numérico
            ForEach(positions.indices, id: \.self) { index in
                ZStack {
                    Button {
                        if let selectedIndex = selectedInputIndex {
                            if numbers[index].isEmpty {
                                if !inputNumbers[selectedIndex].isEmpty {
                                    inputNumbers[selectedIndex].removeLast()
                                }
                            } else if inputNumbers[selectedIndex].count < 4 {
                                inputNumbers[selectedIndex] += numbers[index]
                            }
                        }
                    } label: {
                        ZStack{
                            Image("tecla")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                            
                            Text(numbers[index % numbers.count])
                                .font(.custom("RifficFree-Bold", size: 45))
                                .foregroundColor(Color.Cafe)
                        }
                    }
                }.position(x: appData.UISW * positions[index], y: appData.UISH * 0.9)
            }
            
            Image("borrar")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .position(x: appData.UISW * 0.84, y: appData.UISH * 0.9)
                .allowsHitTesting(false)
            
            // Botón para evaluar las respuestas
            Button {
                if inputNumbers.contains("") || selectedInputIndex == nil {
                    RiveManager.shared.setInput("selectedState", value: 1.0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        RiveManager.shared.setInput("selectedState", value: 0.0)
                    }
                } else {
                    RiveManager.shared.setInput("selectedState", value: 2.0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        RiveManager.shared.setInput("selectedState", value: 0.0)
                    }
                    evaluateRound()
                    saveChallengeResults()
                    incrementExercises()
                    
                }
            } label: {
                Image("done")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 85)
            }
            .opacity(inputNumbers.contains("") || selectedInputIndex == nil ? 0.5 : 1.0)
            .position(x: appData.UISW * 0.93, y: appData.UISH * 0.9)
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(Color.VerdeAns)
                    .frame(width: 100, height: 50)
                
                Text("\(round) / 3")
                    .font(.custom("RifficFree-Bold", size: 29))
                    .foregroundColor(Color.AmarilloAns)
            }.position(x: appData.UISW * 0.8, y: appData.UISH * 0.195)
            
            Text("Ronda")
                .font(.custom("RifficFree-Bold", size: 29))
                .foregroundColor(.white)
                .position(x: appData.UISW * 0.8, y: appData.UISH * 0.14)
            
            
            Button{
                            withAnimation(.easeInOut(duration: 0.1)) {
                                appData.isTuto = true
                            }
                        } label: {
                            Image("tutorialIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60)
                        }.position(x: appData.UISW * 0.94, y: appData.UISH * 0.19)


            // Mostrar botón de resultados
            if showResults {
                Color.black.opacity(0.85)
                    .ignoresSafeArea()
                
                Text("Calificación: \(correctCount) / \(results.count)")
                    .font(.custom("RifficFree-Bold", size: 35))
                    .foregroundColor(Color.white)
                    .position(x: appData.UISW * 0.5, y: appData.UISH * 0.150)
                
                let inputForRive = calculateRiveInput(from: correctCount)
                let rive = RiveViewModel(fileName: "cal-reto", stateMachineName: "Actions", artboardName: selectedAvatar)
                rive.view()
                    .scaleEffect(1)
                    .allowsHitTesting(false)
                    .onAppear {
                        rive.setInput("Number 1", value: inputForRive)
                        SoundManager.instance.stopSound(for: .ChallengeFinal)
                        if appData.sound {
                            SoundManager.instance.playSoundFromStart(sound: .ExerciseResult, loop: false)
                            if correctCount < 3 {
                                SoundManager.instance.playDialogES(sound: .reto1, loop: false)
                            } else if correctCount < 6 && correctCount > 2 {
                                SoundManager.instance.playDialogES(sound: .reto2, loop: false)
                            } else if correctCount < 9 && correctCount > 5 {
                                SoundManager.instance.playDialogES(sound: .reto3, loop: false)
                            } else if correctCount == 9 {
                                SoundManager.instance.playDialogES(sound: .reto4, loop: false)
                            }
                        }
                    }
                
                if correctCount < 3  {
                    Text(appData.localizationManager.localizedString(for: "cal-reto1" ))
                        .font(.custom("RifficFree-Bold", size: 30))
                        .frame(width: appData.UISW * 0.9)
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.65)
                        .foregroundColor(.buttonLblColor)
                }
                if correctCount < 6 && correctCount > 2  {
                    Text(appData.localizationManager.localizedString(for: "cal-reto2" ))
                        .font(.custom("RifficFree-Bold", size: 30))
                        .frame(width: appData.UISW * 0.9)
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.65)
                        .foregroundColor(.buttonLblColor)
                }
                
                if correctCount < 9 && correctCount > 5  {
                    Text(appData.localizationManager.localizedString(for: "cal-reto3" ))
                        .font(.custom("RifficFree-Bold", size: 30))
                        .frame(width: appData.UISW * 0.9)
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.65)
                        .foregroundColor(.buttonLblColor)
                }
                
                if correctCount == 9 {
                    Text(appData.localizationManager.localizedString(for: "cal-reto4" ))
                        .font(.custom("RifficFree-Bold", size: 30))
                        .frame(width: appData.UISW * 0.9)
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.65)
                        .foregroundColor(.buttonLblColor)
                }
                
                
                if showPopup {
                    Color.black.opacity(0.7).ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.35)){
                                showPopup = false
                            }
                        }
                    ResultRetoView(
                        results: results,
                        operationResults: operationResults,
                        expectedResults: expectedResults,
                        closeAction: {
                            withAnimation { showPopup = false }
                        }
                    )
                    .transition(.scale)

                }
                
                // Botón Ver resultados / Cerrar
                Button {
                    withAnimation {
                        showPopup.toggle() // Alternar el estado del popup
                    }
                } label: {
                    Text(showPopup ? "Cerrar" : "Ver resultados")
                        .font(.custom("RifficFree-Bold", size: appData.UISW * 0.025))
                        .padding()
                        .padding(.horizontal)
                        .foregroundColor(.buttonLblColor)
                        .background(Color.CelesteBG)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white, lineWidth: 7.5)
                        )
                        .frame(width: showPopup ? appData.UISW * 0.3 : appData.UISW * 0.3)
                }
                .position(x: appData.UISW * 0.5, y: appData.UISH * 0.85)
                .animation(.bouncy(duration: 0.15), value: showPopup)
                
            }
            Button {
                withAnimation(.easeInOut(duration: 0)) {
                    back = false
                    SoundManager.instance.stopSound(for: .ChallengeFinal)
                    SoundManager.instance.stopDialog()
                    SoundManager.instance.stopSound(for: .ExerciseResult)
                    if appData.sound {
                        SoundManager.instance.playSound(sound: .MainTheme)
                    }
                }
            } label: {
                Image("back")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
            }.position(x: appData.UISW * 0.06, y: appData.UISH * 0.09)
            
            Button {
                    withAnimation(.easeInOut(duration: 0.1)) {
                                appData.sound.toggle()
                            }
                        } label: {
                            Image(appData.sound ? "sound" : "mute")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60)
                        }.position(x: appData.UISW * 0.94, y: appData.UISH * 0.09)
            
            if appData.isTuto {
                TutorialView(viewType: .reto)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            randomNumbers.append(contentsOf: randomNumbers)
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
    
    // MARK: - Evaluar la ronda actual
    private func evaluateRound() {
        let expectedValues = [
            randomNumbers[0] * randomNumbers[1],
            randomNumbers[2] * randomNumbers[3],
            randomNumbers[4] * randomNumbers[5]
        ]
        
        for i in 0..<3 {
            let userInput = Int(inputNumbers[i]) ?? 0
            userAnswers.append(userInput)
            
            // Almacenar las operaciones
            operationResults.append((randomNumbers[i * 2], randomNumbers[i * 2 + 1], userInput))
            expectedResults.append(expectedValues[i])
            
            // Evaluar si la respuesta es correcta
            if userInput == expectedValues[i] {
                results[(round - 1) * 3 + i] = true
            } else {
                results[(round - 1) * 3 + i] = false
            }
        }
        
        if round < 3 {
            round += 1
            inputNumbers = ["", "", ""]
            randomNumbers = [
                Int.random(in: 2...9),
                Int.random(in: 100...1000),
                Int.random(in: 2...9),
                Int.random(in: 100...1000),
                Int.random(in: 2...9),
                Int.random(in: 100...1000)
            ]
        } else {
            showResults = true
            correctCount = results.filter { $0 }.count
            
            // Guardar los resultados en Core Data
            saveChallengeResults()
            incrementExercises()
        }
    }
    
    // MARK: - Guardar los resultados del reto en Core Data
    private func saveChallengeResults() {
        let aciertos = Int16(correctCount)
        let errores = Int16(9 - correctCount)
        
        DataManager.shared.addEjercicio(
            to: selectedPerfil,
            aciertos: aciertos,
            errores: errores,
            tabla: 0,
            tipo: "Reto"
        )
    }
    
    func calculateRiveInput(from correctCount: Int) -> Double {
        switch correctCount {
        case 0...2:
            return 1.0
        case 3...5:
            return 3.0
        case 6...8:
            return 6.0
        case 9:
            return 9.0
        default:
            return 0.0
        }
    }
}

#Preview {
    @State var previewBack = true
    let previewIncrementExercises: () -> Void = {}

    let dummyPerfil = Perfil(context: DataManager.shared.persistentContainer.viewContext)

    return RetoView(
        back: $previewBack,
        selectedAvatar: "avatar1",
        selectedPerfil: dummyPerfil, incrementExercises: previewIncrementExercises
    )
    .environmentObject(AppData())
    .environmentObject(PerfilesViewModel())
}
