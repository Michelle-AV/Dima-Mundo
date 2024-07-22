//
//  Fondo 2.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 13/07/24.
//

import SwiftUI
import RiveRuntime

struct FondoMP: View {
    let rive = RiveViewModel(fileName: "fondos", artboardName: "makeProfile")
    var body: some View {
        ZStack{
            rive.view()
                .scaleEffect(1.1)
            
        }
        .ignoresSafeArea()
    }
}

struct FondoCP: View {
    let rive = RiveViewModel(fileName: "fondos", artboardName: "chooseProfile")
    var body: some View {
        ZStack{
            rive.view()
                .scaleEffect(1.1)
            
        }
        .ignoresSafeArea()
    }
}

