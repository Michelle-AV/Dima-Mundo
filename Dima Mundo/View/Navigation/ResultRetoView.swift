//
//  ResultRetoView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 05/09/24.
//
import SwiftUI

struct ResultRetoView: View {
    let results: [Bool]
    let operationResults: [(Int, Int, Int)] // (multiplicando, multiplicador, resultado usuario)
    let expectedResults: [Int] // Resultados esperados
    let closeAction: () -> Void
    
    @EnvironmentObject var appData: AppData
    @State private var showDetail: Bool = false
    @State private var selectedOperation: (Int, Int, Int)? = nil

    var body: some View {
        ZStack {
            ZStack {
                Color.white
                    .frame(width: appData.UISW * 0.875, height: appData.UISH * 0.53)
                    .cornerRadius(20)
                    .position(x: appData.UISW * 0.5, y: appData.UISH * 0.5)
                
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(Color.CelesteBG)
                    .frame(width: appData.UISW * 0.875, height: appData.UISH * 0.03)
                    .position(x: appData.UISW * 0.5, y: appData.UISH * 0.26)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color.CelesteBG)
                    .frame(width: appData.UISW * 0.875, height: appData.UISH * 0.07)
                    .position(x: appData.UISW * 0.5, y: appData.UISH * 0.235)
                    .overlay {
                        Text("Resultados del Reto")
                            .font(.custom("RifficFree-Bold", size: 30))
                            .foregroundColor(Color.buttonLblColor)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.24)
                    }
                
                // Mostrar las 9 operaciones
                ForEach(0..<9, id: \.self) { index in
                    operationView(index: index)
                        .position(x: index % 3 == 0 ? appData.UISW * 0.2 : (index % 3 == 1 ? appData.UISW * 0.5 : appData.UISW * 0.8),
                                  y: index < 3 ? appData.UISH * 0.35 : (index < 6 ? appData.UISH * 0.5 : appData.UISH * 0.65))
                }
            }
            if showDetail {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showDetail = false
                    }
            }
            if showDetail, let operation = selectedOperation {
                showDetailPopup(for: operation)
                    .transition(.scale)
            }
            
        }
    }
    
    @ViewBuilder
    func operationView(index: Int) -> some View {
        let operation = operationResults[index]
        let expectedResult = expectedResults[index]
        
        ZStack {
            // Fondo de la operación
            RoundedRectangle(cornerRadius: 15)
                .fill(results[index] ? Color.CelesteBG : Color(red: 0.9, green: 0.9, blue: 0.9))
                .frame(width: appData.UISW * 0.20, height: appData.UISH * 0.07)
            
            // Mostrar operación y resultado del usuario
            ZStack {
                Text("\(operation.0) x \(operation.1) = \(operation.2)")
                    .font(.custom("RifficFree-Bold", size: 25))
                    .foregroundColor(results[index] ? .buttonLblColor : .gray)
                
                if !results[index] {
                    // Botón para ver el desglose completo de la operación
                    Button(action: {
                        selectedOperation = operation
                        withAnimation {
                            showDetail = true
                        }
                    }) {
                        Text("Ver resultado correcto")
                            .font(.custom("RifficFree-Bold", size: 20))
                            .foregroundColor(.numberBG)
                    }
                    .offset(y: appData.UISH * 0.055)
                } else {
                    Text("¡Ejercicio correcto!")
                        .foregroundColor(.buttonLblColor)
                        .font(.custom("RifficFree-Bold", size: 20))
                        .offset(y: appData.UISH * 0.055)
                }
            }
            
            ZStack {
                Circle()
                    .fill(Color.numberBG)
                    .frame(height: appData.UISW * 0.04)
                
                Text("\(index + 1)")
                    .foregroundColor(.white)
                    .font(.custom("RifficFree-Bold", size: 20))
            }
            .offset(x: -appData.UISW * 0.1, y: -appData.UISH * 0.03)
            
           
        }
    }

    // Pop-up con el detalle del resultado correcto
    @ViewBuilder
    func showDetailPopup(for operation: (Int, Int, Int)) -> some View {
        ZStack {
            Color.white
                .frame(width: appData.UISW * 0.35, height: appData.UISH * 0.5)
                .cornerRadius(20)

            VStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.CelesteBG)
                        .frame(width: appData.UISW * 0.20, height: appData.UISH * 0.07)
                    
                    Text("\(operation.0) × \(operation.1) = \(operation.0 * operation.1)")
                        .font(.custom("RifficFree-Bold", size: 25))
                        .foregroundColor(.buttonLblColor)
                }
                
                Text("Procedimiento:")
                    .font(.custom("RifficFree-Bold", size: 25))
                    .foregroundColor(.numberBG)
                    .padding()

                VStack(alignment: .leading ,spacing: 5) {
                    let centena = (operation.1 / 100 * 100) * operation.0
                    let decena = ((operation.1 % 100) / 10 * 10) * operation.0
                    let unidad = (operation.1 % 10) * operation.0
                    HStack (spacing: 30){
                    Text("Centenas: ")
                        .foregroundColor(.gray)
                    Text("\(operation.0) × \(operation.1 / 100 * 100) = \(centena)")
                        .foregroundColor(.gray)
                    }
                    HStack(spacing: 40){
                        Text("Decenas: ")
                            .foregroundColor(.gray)
                        Text("\(operation.0) × \((operation.1 % 100) / 10 * 10) = \(decena)")
                            .foregroundColor(.gray)
                    }
                    HStack(spacing: 35){
                    Text("Unidades: ")
                            .foregroundColor(.gray)
                    Text("\(operation.0) × \((operation.1 % 10)) = \(unidad)")
                            .foregroundColor(.gray)
                    }
                    
                }
                .font(.custom("RifficFree-Bold", size: 20))

                let centena = (operation.1 / 100 * 100) * operation.0
                let decena = ((operation.1 % 100) / 10 * 10) * operation.0
                let unidad = (operation.1 % 10) * operation.0
                
                Text("\(centena) + \(decena) + \(unidad) = \(operation.0 * operation.1)")
                    .font(.custom("RifficFree-Bold", size: 25))
                    .foregroundColor(.buttonLblColor)
                    .offset(y: 20)
                
                Button(action: {
                    withAnimation {
                        showDetail = false
                    }
                }) {
                    Text("¡Entendido!")
                        .font(.custom("RifficFree-Bold", size: 25))
                        .foregroundColor(.white)
                        .padding(7.5)
                        .padding(.horizontal, 30)
                        .background(Color.numberBG)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
        }
    }
}

#Preview {
    ResultRetoView(
        results: [false, false, true, false, true, false, true, true, false],
        operationResults: [(8, 792, 120), (1, 555, 555), (1, 5, 5), (8, 792, 120), (1, 555, 555), (1, 5, 5), (1, 5, 5), (1, 5, 5), (1, 5, 5)],
        expectedResults: [6338, 555, 5, 6338, 555, 5, 5, 5, 5],
        closeAction: { print("Cerrando vista") }
    )
    .environmentObject(AppData())
}
