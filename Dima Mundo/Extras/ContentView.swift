import SwiftUI
import RiveRuntime

struct ContentView: View {
    @State private var selectedCharacter = "jack3"
    @State private var artboardName = "podiumAB"
    @State private var stepperValue = 0
    
    @State private var variablestar = true
    
    
    var body: some View {
        let rive = RiveViewModel(fileName: "cal-reto", stateMachineName: "Actions", artboardName: "avatar3")
        
        ZStack {
            Color.gray
            
                rive.view()
                    .scaleEffect(1)
                    .onChange(of: variablestar) {
                        rive.setInput("Number 1", value: 1.0)

                    }
            


            
            Circle()
                    .frame(width: 100)
                    .position(x: 500, y:900)
                    .onTapGesture {
                        variablestar = false
                    }
                    
//            Stepper("Value: \(stepperValue)", value: $stepperValue, in: 0...10)
//                .onChange(of: stepperValue) { newValue in
//                    if newValue == 1 {
//                        rive.setInput("Number 1", value: 1.0)
//                    }
//                }
//                .padding()
        }
    }
}

#Preview{
    ContentView()
}
