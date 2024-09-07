import SwiftUI
import RiveRuntime

struct TablesExView: View {
    
    @Binding var table: Int
    @Binding var back: Bool
    @EnvironmentObject var appData: AppData
    @State private var inputNumber: String = ""
    @State private var resultMessage: String = ""
    @State var exercise: Int = 1
    @State private var randomNumber: Int = Int.random(in: 1...10)
    @State private var usedRandomNumbers: [Int] = []
    @State private var results: [Bool] = [Bool](repeating: false, count: 5)
    @State private var userAnswers: [Int] = [] // <-- Nuevo array para almacenar respuestas del usuario
    @State private var showResults: Bool = false
    @State private var correctCount: Int = 0
    @State private var showPopup: Bool = false
    var selectedAvatar: String
    var incrementExercises: () -> Void
    var selectedPerfil: Perfil
    let positions: [CGFloat] = [0.07, 0.147, 0.224, 0.301, 0.378, 0.455, 0.531, 0.608, 0.685, 0.764, 0.842]
    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ""]
    
    var body: some View {
        ZStack {
            Image("retof")
                .resizable()
                .scaledToFill()
                .frame(width: appData.UISW, height: appData.UISH)
            
            RiveManager.shared.riveModel.view()
                .scaleEffect(0.6)
                .allowsHitTesting(false)
                .position(x: appData.UISW * 0.14, y: appData.UISH * 0.57)
            
            Image("times")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .position(x: appData.UISW * 0.405, y: appData.UISH * 0.34)
            
            Image("equal")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .position(x: appData.UISW * 0.565, y: appData.UISH * 0.34)
            
            ForEach(positions.indices, id: \.self) { index in
                ZStack {
                    Button {
                        if numbers[index].isEmpty {
                            if !inputNumber.isEmpty {
                                inputNumber.removeLast()
                            }
                        } else if inputNumber.count < 3 {
                            inputNumber += numbers[index]
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
            
            Button {
                if inputNumber.isEmpty {
                    RiveManager.shared.setInput("selectedState", value: 1.0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        RiveManager.shared.setInput("selectedState", value: 0.0)
                    }
                } else {
                    RiveManager.shared.setInput("selectedState", value: 2.0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        RiveManager.shared.setInput("selectedState", value: 0.0)
                    }
                    
                    let expectedValue = table * randomNumber
                    if let inputValue = Int(inputNumber) {
                        // Almacenar la respuesta ingresada por el usuario
                        userAnswers.append(inputValue)  // <-- Aquí se almacena la respuesta del usuario
                        
                        if inputValue == expectedValue {
                            resultMessage = "Correcto"
                            results[exercise - 1] = true
                        } else {
                            resultMessage = "Incorrecto"
                            results[exercise - 1] = false
                        }
                    }
                    
                    if exercise < 5 {
                        exercise += 1
                        repeat {
                            randomNumber = Int.random(in: 1...10)
                        } while usedRandomNumbers.contains(randomNumber)
                        usedRandomNumbers.append(randomNumber)
                        inputNumber = ""
                    } else {
                        showResults = true
                        correctCount = results.filter { $0 }.count
                        
                        // Guardar los resultados en Core Data
                        saveExerciseResults()
                        
                        incrementExercises() // Incrementar el contador de ejercicios completados
                    }
                }
            } label: {
                Image("done")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 85)
            }
            .opacity(inputNumber.isEmpty ? 0.5 : 1.0)
            .position(x: appData.UISW * 0.93, y: appData.UISH * 0.9)
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.VerdePiz)
                    .frame(width: 110, height: 110)
                
                Text("\(table)")
                    .font(.custom("RifficFree-Bold", size: 65))
                    .foregroundColor(.white)
            }.position(x: appData.UISW * 0.33, y: appData.UISH * 0.34)
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.VerdePiz)
                    .frame(width: 110, height: 110)
                
                Text("\(randomNumber)")
                    .font(.custom("RifficFree-Bold", size: 65))
                    .foregroundColor(.white)
            }.position(x: appData.UISW * 0.48, y: appData.UISH * 0.34)
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.VerdePiz)
                    .frame(width: 140, height: 110)
                
                Text(inputNumber)
                    .font(.custom("RifficFree-Bold", size: 65))
                    .foregroundColor(.white)
            }.position(x: appData.UISW * 0.66, y: appData.UISH * 0.34)
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(Color.VerdeAns)
                    .frame(width: 100, height: 50)
                
                Text("\(exercise) / 5")
                    .font(.custom("RifficFree-Bold", size: 29))
                    .foregroundColor(Color.AmarilloAns)
            }.position(x: appData.UISW * 0.8, y: appData.UISH * 0.195)
            
            Text("Ejercicio")
                .font(.custom("RifficFree-Bold", size: 29))
                .foregroundColor(.white)
                .position(x: appData.UISW * 0.8, y: appData.UISH * 0.14)
            
            Button {
                withAnimation(.easeInOut(duration: 0.1)) {
                    appData.isTuto = true
                }
            } label: {
                Image("tutorialIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                
            }.position(x: appData.UISW * 0.94, y: appData.UISH * 0.19)
            
            if showResults {
                Color.black.opacity(0.85)
                    .ignoresSafeArea()

                Text("Calificación: \(correctCount) / \(results.count)")
                    .font(.custom("RifficFree-Bold", size: 35))
                    .foregroundColor(Color.white)
                    .position(x: appData.UISW * 0.5, y: appData.UISH * 0.150)
                
                let correctCountDouble = Double(correctCount)
                let rive = RiveViewModel(fileName: "cal-ejercicios", stateMachineName: "Actions", artboardName: selectedAvatar)
                
                rive.view()
                    .scaleEffect(1)
                    .allowsHitTesting(false)
                    .onAppear {
                        rive.setInput("Number 1", value: correctCountDouble)
                        
                        if appData.sound {
                            SoundManager.instance.stopSound(for: .Exercise)
                            SoundManager.instance.playSoundFromStart(sound: .ExerciseResult, loop: false)
                        }
                    }
                if correctCountDouble == 0 {
                    Text(appData.localizationManager.localizedString(for: "cal-ejercicio0" ))
                        .font(.custom("RifficFree-Bold", size: 30))
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.65)
                        .foregroundColor(.buttonLblColor)
                }
                if correctCountDouble >= 1 && correctCountDouble <= 2  {
                    Text(appData.localizationManager.localizedString(for: "cal-ejercicio1-2" ))
                        .font(.custom("RifficFree-Bold", size: 30))
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.65)
                        .foregroundColor(.buttonLblColor)
                }
                if correctCountDouble >= 3 && correctCountDouble <= 4  {
                    Text(appData.localizationManager.localizedString(for: "cal-ejercicio3-4" ))
                        .font(.custom("RifficFree-Bold", size: 30))
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.65)
                        .foregroundColor(.buttonLblColor)
                }
                if correctCountDouble == 5  {
                    Text(appData.localizationManager.localizedString(for: "cal-ejercicio5" ))
                        .font(.custom("RifficFree-Bold", size: 30))
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.65)
                        .foregroundColor(.buttonLblColor)
                }
                
            }
            
            Button {
                withAnimation(.easeInOut(duration: 0)) {
                    back = false
                    SoundManager.instance.stopSound(for: .ExerciseResult)
                    SoundManager.instance.stopSound(for: .Exercise)
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
            
            if showPopup {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.35)){
                            showPopup = false
                        }
                    }
                ResultsView(results: results, table: table, randomNumbers: usedRandomNumbers, userAnswers: userAnswers, closeAction: {
                    showPopup = false
                })
                .transition(.scale)
            }
            
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
            
        if showResults{
            Button {
                            withAnimation {
                                showPopup.toggle() // Alternar el estado del popup
                            }
                        } label: {
                            Text(showPopup ? "Cerrar" : "Ver resultados")
                                .font(.custom("RifficFree-Bold", size: showPopup ? 25 : 25))
                                .padding()
                                .padding(.horizontal)
                                .foregroundColor(.buttonLblColor)
                                .background(Color.CelesteBG)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white, lineWidth: 7.5)
                                )
                                .frame(width: showPopup ? 180 : appData.UISW * 0.2) // Animar el tamaño
                        }
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.85)
                        .animation(.bouncy(duration: 0.15), value: showPopup)
        }
            
            if appData.isTuto {
                TutorialView(viewType: .ejercicios)
            }
            
        }.ignoresSafeArea()
        .onAppear {
            usedRandomNumbers.append(randomNumber)
        }
    }
    
    // MARK: - Guardar los resultados del ejercicio en Core Data
    private func saveExerciseResults() {
        let aciertos = Int16(correctCount)
        let errores = Int16(5 - correctCount)
        
        DataManager.shared.addEjercicio(
            to: selectedPerfil,
            aciertos: aciertos,
            errores: errores,
            tabla: Int16(table),
            tipo: "Ejercicio"
        )
    }
}

#Preview {
    @State var previewBack = true

    let previewIncrementExercises: () -> Void = {}

    // Create a dummy profile for preview purposes
    let dummyPerfil = Perfil(context: DataManager.shared.persistentContainer.viewContext)

    return TablesExView(
        table: .constant(1), back: $previewBack,
        selectedAvatar: "avatar1",
        incrementExercises: previewIncrementExercises,
        selectedPerfil: dummyPerfil
    )
    .environmentObject(AppData())
    .environmentObject(PerfilesViewModel())
}
