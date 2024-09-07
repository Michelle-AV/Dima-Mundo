//
//  ResultsView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 04/09/24.
//
import SwiftUI

struct ResultsView: View {
    let results: [Bool]
    let table: Int
    let randomNumbers: [Int]
    let userAnswers: [Int]  // <-- Variable para respuestas del usuario
    let closeAction: () -> Void
    
    @EnvironmentObject var appData: AppData
    
    var correctAnswersCount: Int {
        results.filter { $0 }.count
    }
    
    var body: some View {
        ZStack {
            ZStack {
                Color.white
                    .frame(width: appData.UISW * 0.875, height: appData.UISH * 0.56)
                    .cornerRadius(20)
                    .position(x: appData.UISW * 0.5, y: appData.UISH * 0.5)
                
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(Color.CelesteBG)
                    .frame(width: appData.UISW * 0.875, height: appData.UISH * 0.03)
                    .position(x: appData.UISW * 0.5, y: appData.UISH * 0.28)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color.CelesteBG)
                    .frame(width: appData.UISW * 0.875, height: appData.UISH * 0.07)
                    .position(x: appData.UISW * 0.5, y: appData.UISH * 0.25)
                    .overlay {
                        Text("Ejercicios resueltos")
                            .font(.custom("RifficFree-Bold", size: 30))
                            .foregroundColor(Color.buttonLblColor)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.255)
                    }
                
                // Mostrar cada operación
                operationView(index: 0)
                    .position(x: appData.UISW * 0.2, y: appData.UISH * 0.4)
                operationView(index: 1)
                    .position(x: appData.UISW * 0.5, y: appData.UISH * 0.4)
                operationView(index: 2)
                    .position(x: appData.UISW * 0.8, y: appData.UISH * 0.4)
                operationView(index: 3)
                    .position(x: appData.UISW * 0.35, y: appData.UISH * 0.6)
                operationView(index: 4)
                    .position(x: appData.UISW * 0.65, y: appData.UISH * 0.6)
            }
            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.5)
        }
    }
    
    @ViewBuilder
    func operationView(index: Int) -> some View {
        ZStack {
            // Fondo de la operación
            RoundedRectangle(cornerRadius: 15)
                .fill(results[index] ? Color.CelesteBG : Color(red: 0.9, green: 0.9, blue: 0.9))
                .frame(width: appData.UISW * 0.20, height: appData.UISH * 0.07)
            
            // Texto de la operación
            Text("\(table) x \(randomNumbers[index]) = \(results[index] ? table * randomNumbers[index] : userAnswers[index])")
                .font(.custom("RifficFree-Bold", size: 30))
                .foregroundColor(results[index] ? .buttonLblColor : .gray)
            
            Text(results[index] ? "¡Ejercicio correcto!" : "")
                .foregroundColor(.buttonLblColor)
                .font(.custom("RifficFree-Bold", size: 20))
                .offset(x: 0, y: appData.UISH * 0.06)

            
            // Indicador del número de ejercicio
            ZStack {
                Circle()
                    .fill(Color.numberBG)
                    .frame(height: appData.UISW * 0.04)
                
                Text("\(index + 1)")
                    .foregroundColor(.white)
                    .font(.custom("RifficFree-Bold", size: 20))
            }
            .offset(x: -appData.UISW * 0.1, y: -appData.UISH * 0.03)
            
            // Mostrar retroalimentación si la respuesta fue incorrecta
            if !results[index] {
                HStack {
                    Text("Respuesta correcta:")
                        .foregroundColor(.numberBG)
                        .font(.custom("RifficFree-Bold", size: 20))
                    
                    Text("\(table) x \(randomNumbers[index]) = \(table * randomNumbers[index])")
                        .foregroundColor(.buttonLblColor)
                        .font(.custom("RifficFree-Bold", size: 20))
                }
                .offset(x: 0, y: appData.UISH * 0.06)
            }
        }
    }
}

#Preview {
    ResultsView(
        results: [true, false, true, false, true], // Mock de resultados
        table: 1, // La tabla usada en los ejercicios (ejemplo)
        randomNumbers: [5, 8, 7, 6, 9], // Números aleatorios usados en los ejercicios
        userAnswers: [5, 18, 7, 9, 0],  // Respuestas del usuario
        closeAction: { print("Cerrando vista") } // Acción de cierre de ejemplo
    )
    .environmentObject(AppData())
}
