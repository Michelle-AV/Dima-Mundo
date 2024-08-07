//
//  CardView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 21/07/24.
//

import SwiftUI

struct CardView: View {
    
    @Binding var Exercise: Bool
    @Binding var Tabla: Int
    
    var card: Card
    var isSelected: Bool
    @EnvironmentObject var appData: AppData
    var incrementExercises: () -> Void

    var body: some View {
        ZStack {
            Image(card.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: appData.UISH * 0.4)
                .scaleEffect(isSelected ? 1.2 : 1)

            if isSelected {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0)) {
                        Exercise = true
                    }
                    if let tableNumber = numberFromLabel(card.label){
                        Tabla = tableNumber
                    }
                }) {
                    Text("Iniciar")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    func numberFromLabel(_ label: String) -> Int? {
        let mapping: [String: Int] = [
            "Uno": 1,
            "Dos": 2,
            "Tres": 3,
            "Cuatro": 4,
            "Cinco": 5,
            "Seis": 6,
            "Siete": 7,
            "Ocho": 8,
            "Nueve": 9,
            "Diez": 10,
            "Once": 11
        ]
        return mapping[label]
    }
}
