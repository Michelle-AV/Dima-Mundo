import SwiftUI
import RiveRuntime

struct RetoView: View {
    
    @Binding var back: Bool
    
    @EnvironmentObject var appData: AppData
    @ObservedObject var viewModel = PerfilesViewModel()
    @State private var selectedPerfil: Perfil?
    @StateObject var riveModel: RiveModel
    @State var isTapped: Bool = false
    @State private var inputNumbers: [String] = ["", "", ""]
    @State private var selectedInputIndex: Int? = nil
    @State private var resultMessage: String = ""
    @State var round: Int = 1
    @State private var randomNumbers: [Int] = [
        Int.random(in: 2...9),     // randomNumber1
        Int.random(in: 100...1000), // randomNumber2
        Int.random(in: 2...9),     // randomNumber3
        Int.random(in: 100...1000), // randomNumber4
        Int.random(in: 2...9),     // randomNumber5
        Int.random(in: 100...1000)  // randomNumber6
    ]
    
    @State private var usedRandomNumbers: [Int] = []
    @State private var results: [Bool] = [Bool](repeating: false, count: 9)
    @State private var showResults: Bool = false
    @State private var correctCount: Int = 0  // Count of correct answers
    var selectedAvatar: String
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    var incrementExercises: () -> Void

    let positions: [CGFloat] = [0.07, 0.147, 0.224, 0.301, 0.378, 0.455, 0.531, 0.608, 0.685, 0.764, 0.842]
    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ""]
    
    var body: some View {
        ZStack {
            Image("retof")
                .resizable()
                .scaledToFill()
                .frame(width: UISW * 1, height: UISH * 1)
            
            ForEach(0..<3) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.VerdePiz)
                        .frame(width: 110, height: 110)
                    
                    Text("\(randomNumbers[index * 2])")
                        .font(.custom("RifficFree-Bold", size: 65))
                        .foregroundColor(.white)
                }.position(x: UISW * 0.32, y: UISH * CGFloat(0.2 + (Double(index) * 0.18)))
                
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.VerdePiz)
                        .frame(width: 110, height: 110)
                    
                    Text("\(randomNumbers[index * 2 + 1])")
                        .font(.custom("RifficFree-Bold", size: 50))
                        .foregroundColor(.white)
                }.position(x: UISW * 0.48, y: UISH * CGFloat(0.2 + (Double(index) * 0.18)))
                
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
                .position(x: UISW * 0.66, y: UISH * CGFloat(0.2 + (Double(index) * 0.18)))
                .onTapGesture {
                    selectedInputIndex = index
                }
            }
            
            RiveViewModel(fileName: riveModel.fileName, stateMachineName: "Actions", artboardName: "inGameAB").view()
                .id(riveModel.fileName)
                .background(.clear)
                .scaleEffect(0.6)
                .allowsHitTesting(false)
                .position(x: UISW * 0.14, y: UISH * 0.57)

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
                }.position(x: UISW * positions[index], y: UISH * 0.9)
            }
            
            Image("borrar")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .position(x: UISW * 0.84, y: UISH * 0.9)
                .allowsHitTesting(false)
            
            Button {
                let expectedValues = [
                    randomNumbers[0] * randomNumbers[1],
                    randomNumbers[2] * randomNumbers[3],
                    randomNumbers[4] * randomNumbers[5]
                ]
                
                for i in 0..<3 {
                    if let inputValue = Int(inputNumbers[i]), inputValue == expectedValues[i] {
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
                    incrementExercises()
                    correctCount = results.filter { $0 }.count
                }
                
            } label: {
                Image("done")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 85)
            }
            .opacity(inputNumbers.contains("") || selectedInputIndex == nil ? 0.5 : 1.0)
            .disabled(inputNumbers.contains("") || selectedInputIndex == nil)
            .position(x: UISW * 0.93, y: UISH * 0.9)
            
            
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(Color.VerdeAns)
                    .frame(width: 100, height: 50)
                
                Text("\(round) / 3")
                    .font(.custom("RifficFree-Bold", size: 29))
                    .foregroundColor(Color.AmarilloAns)
            }.position(x: UISW * 0.8, y: UISH * 0.195)
            
                
            Text("Ronda")
                .font(.custom("RifficFree-Bold", size: 29))
                .foregroundColor(Color.white)
                .position(x: UISW * 0.8, y: UISH * 0.14)
            
            Button {
                withAnimation(.easeInOut(duration: 0.1)) {
                    appData.sound.toggle()
                }
            } label: {
                Image(appData.sound ? "sound" : "mute")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
            }.position(x: UISW * 0.94, y: UISH * 0.09)
            
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
            
            Image("retog")
                .resizable()
                .scaledToFit()
                .frame(width: UISW * 1, height: UISH * 1)
                .opacity(0)
                .allowsHitTesting(false)
            ZStack {
                Image("times")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .center)
                    .position(x: appData.UISW * 0.40, y: appData.UISH * 0.20)
                
                Image("times")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .center)
                    .position(x: appData.UISW * 0.40, y: appData.UISH * 0.56)
                
                Image("times")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .center)
                    .position(x: appData.UISW * 0.40, y: appData.UISH * 0.38)
                
                Image("equal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .center)
                    .position(x: appData.UISW * 0.565, y: appData.UISH * 0.56)
                
                Image("equal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .center)
                    .position(x: appData.UISW * 0.565, y: appData.UISH * 0.20)
                
                Image("equal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .center)
                    .position(x: appData.UISW * 0.565, y: appData.UISH * 0.38)
            }
            
            
            
            if showResults {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
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
                        }
                    }
            }
            
            Button {
                withAnimation(.easeInOut(duration: 0)) {
                    back = false
                    SoundManager.instance.stopSound(for: .ChallengeFinal)
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
            }.position(x: UISW * 0.06, y: UISH * 0.09)
            
            if appData.isTuto {
                TutorialView(viewType: .reto)
            }
            
        }
        .ignoresSafeArea()
        .onAppear {
            usedRandomNumbers.append(contentsOf: randomNumbers)
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
    // Define initial state variables
    @State var previewBack = true

    // Define the Rive model to be used
    let previewRiveModel = RiveModel()

    // Define a dummy incrementExercises function
    let previewIncrementExercises: () -> Void = {
       
    }

    return RetoView(
        back: $previewBack,
        riveModel: previewRiveModel,
        selectedAvatar: "avatar1",
        incrementExercises: previewIncrementExercises
    )
    .environmentObject(AppData())
    .environmentObject(PerfilesViewModel())
}
