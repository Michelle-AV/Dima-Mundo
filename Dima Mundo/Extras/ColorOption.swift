//
//  ColorOption.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 02/07/24.
//

import SwiftUI

enum ColorOption {
    case azulFuerte, azul, turquesa, naranja, morado, rosa
    
    var id: ColorOption { self }
    
    var color: Color {
        switch self {
        case .azulFuerte:
            return Color.AzulFuerte
        case .azul:
            return Color.Azul
        case .turquesa:
            return Color.Turquesa
        case .naranja:
            return Color.Naranja
        case .morado:
            return Color.Morado
        case .rosa:
            return Color.Rosa
        }
    }
}
