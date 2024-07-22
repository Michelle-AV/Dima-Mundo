//
//  ContentView.swift
//  Dima Mundo
//
//  Created by Chema Padilla Fdez on 07/06/24.
//

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @State private var selectedCharacter = "jack3"
    @State private var artboardName = "podiumAB"
    @State private var stepperValue = 0
    
    var body: some View {
        let rive = RiveViewModel(fileName: "\(selectedCharacter)", stateMachineName: "Actions", artboardName: "\(artboardName)")
        
        VStack {
            
            HStack {
                rive.view()
                    .scaleEffect(1)

            }

            Stepper("Value: \(stepperValue)", value: $stepperValue, in: 0...10)
                .onChange(of: stepperValue) { newValue in
                    if newValue == 1 {
                        rive.setInput("selectedState", value: 1.0)
                    }
                }
                .padding()
        }
    }
}

#Preview{
    ContentView()
}
