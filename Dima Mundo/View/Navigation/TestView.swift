//
//  TestView.swift
//  Dima Mundo
//
//  Created by Chema Padilla Fdez on 13/08/24.
//

import SwiftUI

struct TestView: View {
    @State private var recognizedText: String = ""
    @State private var isListening: Bool = false
        
    var body: some View {
        VStack {
            Text("Texto Reconocido:")
                .font(.headline)
            
            Text(recognizedText)
                .font(.largeTitle)
                .padding()
                .frame(minHeight: 200)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding()

            MicButton(text: $recognizedText, isListening: $isListening)
                .padding()
        }
        .padding()
    }
}
#Preview {
    TestView()
}
