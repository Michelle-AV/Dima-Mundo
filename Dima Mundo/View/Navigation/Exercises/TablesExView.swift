import SwiftUI
import RiveRuntime

struct TablesExView: View {
    
    @Binding var table: Int
    @Binding var back: Bool
    
    @EnvironmentObject var appData: AppData
    @ObservedObject var viewModel = PerfilesViewModel()
    @State private var selectedPerfil: Perfil?
    @StateObject var riveModel: RiveModel  // Use the passed RiveModel here
    
    @State var sound: Bool = true
    @State var isTapped: Bool = false
    @State private var inputNumber: String = ""
    @State private var resultMessage: String = ""
    @State var exercise: Int = 1
    @State private var randomNumber: Int = Int.random(in: 1...10)
    @State private var usedRandomNumbers: [Int] = []
    @State private var results: [Bool] = [Bool](repeating: false, count: 5)
    @State private var showResults: Bool = false
    @State private var correctCount: Int = 0  // Count of correct answers

    var selectedAvatar: String // Add selectedAvatar to the view

    var incrementExercises: () -> Void
    
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    let positions: [CGFloat] = [0.07, 0.147, 0.224, 0.301, 0.378, 0.455, 0.531, 0.608, 0.685, 0.764, 0.842]
    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ""]
    
    var body: some View {
        ZStack{
            Image("retof")
                .resizable()
                .scaledToFill()
                .frame(width: UISW, height: UISH)
            
            // Rive animation at the bottom
            RiveViewModel(fileName: riveModel.fileName, stateMachineName: "Actions", artboardName: "inGameAB").view()
                .id(riveModel.fileName)
                .background(.clear)
                .scaleEffect(0.6)
                .allowsHitTesting(false)
                .position(x: UISW * 0.14, y: UISH * 0.57)
            
            Image("times")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40, alignment: .center)
                .position(x: appData.UISW * 0.405, y: appData.UISH * 0.34)
            
            Image("equal")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40, alignment: .center)
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
                }.position(x: UISW * positions[index], y: UISH * 0.855)
            }
            
            Image("borrar")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .position(x: UISW * 0.84, y: UISH * 0.855)
                .allowsHitTesting(false)
            
            Button{
                let expectedValue = table * randomNumber
                if let inputValue = Int(inputNumber), inputValue == expectedValue {
                    resultMessage = "Correcto"
                    results[exercise - 1] = true
                } else {
                    resultMessage = "Incorrecto"
                    results[exercise - 1] = false
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
                    incrementExercises()
                    correctCount = results.filter { $0 }.count  // Count correct answers
                }
            } label: {
                Image("done")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 85)
            } .position(x: UISW * 0.93, y: UISH * 0.855)
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.VerdePiz)
                    .frame(width: 110, height: 110)
                
                Text("\(table)")
                    .font(.custom("RifficFree-Bold", size: 65))
                    .foregroundColor(.white)
            }.position(x: UISW * 0.33, y: UISH * 0.34)
            
            ZStack{
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.VerdePiz)
                    .frame(width: 110, height: 110)
                
                Text("\(randomNumber)")
                    .font(.custom("RifficFree-Bold", size: 65))
                    .foregroundColor(.white)
            }.position(x: UISW * 0.48, y: UISH * 0.34)

            
            ZStack{
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.VerdePiz)
                    .frame(width: 140, height: 110)
                
                Text(inputNumber)
                    .font(.custom("RifficFree-Bold", size: 65))
                    .foregroundColor(.white)
            }.position(x: UISW * 0.66, y: UISH * 0.34)

            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(Color.VerdeAns)
                    .frame(width: 100, height: 50)
                
                Text("\(exercise) / 5")
                    .font(.custom("RifficFree-Bold", size: 29))
                    .foregroundColor(Color.AmarilloAns)
            }.position(x: UISW * 0.8, y: UISH * 0.195)
            
            Text("Ronda")
                .font(.custom("RifficFree-Bold", size: 29))
                .foregroundColor(Color.AmarilloAns)
                .position(x: UISW * 0.8, y: UISH * 0.14)
            
            Button{
                withAnimation(.easeInOut(duration: 0.1)) {
                    sound.toggle()
                }
            } label: {
                Image(sound ? "sound" : "mute")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                   
            }.position(x: UISW * 0.955, y: UISH * 0.09)
           
            if showResults {
                Color.black.opacity(0.7)
                
                let correctCountDouble = Double(correctCount)
                let rive = RiveViewModel(fileName: "cal-ejercicios", stateMachineName: "State Machine 1", artboardName: selectedAvatar)
                
                rive.view()
                    .scaleEffect(1)
                    .allowsHitTesting(false)
                    .onAppear {
                        rive.setInput("Number 1", value: correctCountDouble)
                    }
            }
            
            Button{
                withAnimation(.easeInOut(duration: 0)) {
                    back = false
                }
            } label: {
                Image("back")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    
            }.position(x: UISW * 0.04, y: UISH * 0.09)
            
        }.ignoresSafeArea()
        .onAppear {
            usedRandomNumbers.append(randomNumber)
        }
    }
}

#Preview {
    @State var previewBack = true

    let previewRiveModel = RiveModel()

    let previewIncrementExercises: () -> Void = {
       
    }

    return TablesExView(
        table: .constant(1), back: $previewBack,
        riveModel: previewRiveModel,
        selectedAvatar: "avatar1", 
        incrementExercises: previewIncrementExercises
    )
    .environmentObject(AppData())
}
