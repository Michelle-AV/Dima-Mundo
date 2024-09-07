//
//  ImageGroupView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 06/09/24.
//

// MARK: -Este archivo es para las imagenes que tienen patrones repetitivos
import SwiftUI

struct ImageSetView: View {
    @EnvironmentObject var appData: AppData

    var body: some View {
        ZStack {
            Image("times")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .position(x: appData.UISW * 0.40, y: appData.UISH * 0.20)

            Image("times")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .position(x: appData.UISW * 0.40, y: appData.UISH * 0.56)

            Image("times")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .position(x: appData.UISW * 0.40, y: appData.UISH * 0.38)

            Image("equal")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .position(x: appData.UISW * 0.565, y: appData.UISH * 0.56)

            Image("equal")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .position(x: appData.UISW * 0.565, y: appData.UISH * 0.20)

            Image("equal")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .position(x: appData.UISW * 0.565, y: appData.UISH * 0.38)
        }
    }
}
