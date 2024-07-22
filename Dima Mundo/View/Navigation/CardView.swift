//
//  CardView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 21/07/24.
//

import SwiftUI

struct CardView: View {
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
                    incrementExercises()
                    print("Iniciar \(card.label)")
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
}
