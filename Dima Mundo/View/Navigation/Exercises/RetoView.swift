import SwiftUI

struct RetoView: View {
    
    @Binding var back: Bool
    
    @EnvironmentObject var appData: AppData
    @ObservedObject var viewModel = PerfilesViewModel()
    @State private var selectedPerfil: Perfil?
    @StateObject private var riveModel = RiveModel()
    
    @State var sound: Bool = true
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
    
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    var incrementExercises: () -> Void

    let positions: [CGFloat] = [0.07, 0.147, 0.224, 0.301, 0.378, 0.455, 0.531, 0.608, 0.685, 0.764, 0.842]
    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ""]
    
    var body: some View {
        ZStack{
            Image("reto-fondo")
                .resizable()
                .scaledToFit()
                .frame(width: UISW * 1, height: UISH * 1)
            
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
                }.position(x: UISW * positions[index], y: UISH * 0.855)
            }
            
            Image("borrar")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .position(x: UISW * 0.84, y: UISH * 0.855)
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
                }
                
            } label: {
                Image("done")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 85)
            }
            .opacity(inputNumbers.contains("") || selectedInputIndex == nil ? 0.5 : 1.0)
            .disabled(inputNumbers.contains("") || selectedInputIndex == nil)
            .position(x: UISW * 0.93, y: UISH * 0.855)
            
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
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(Color.VerdeAns)
                    .frame(width: 100, height: 50)
                
                Text("\(round) / 3")
                    .font(.custom("RifficFree-Bold", size: 29))
                    .foregroundColor(Color.AmarilloAns)
            }.position(x: UISW * 0.8, y: UISH * 0.195)
            
            if showResults {
                VStack {
                    Text("Resultados:")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    ForEach(results.indices, id: \.self) { index in
                        Text("Ejercicio \(index + 1): \(results[index] ? "Correcto" : "Incorrecto")")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .position(x: UISW * 0.5, y: UISH * 0.5)
            }
            
            Button {
                withAnimation(.easeInOut(duration: 0.1)) {
                    sound.toggle()
                }
            } label: {
                Image(sound ? "sound" : "mute")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
            }.position(x: UISW * 0.936, y: UISH * 0.09)
            
            Button {
                withAnimation(.easeInOut(duration: 0.1)) {
                    back = true
                }
            } label: {
                Image("back")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
            }.position(x: UISW * 0.063, y: UISH * 0.09)
            
            Image("retog")
                .resizable()
                .scaledToFit()
                .frame(width: UISW * 1, height: UISH * 1)
                .opacity(0)
                .allowsHitTesting(false)
            
        }.ignoresSafeArea()
        .onAppear {
            usedRandomNumbers.append(contentsOf: randomNumbers)
        }
    }
}

//#Preview {
//    let back = State(initialValue: false)
//    return RetoView(back: back.projectedValue)
//}

