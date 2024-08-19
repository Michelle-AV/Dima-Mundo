//
//  RiveManager.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 19/08/24.
//

import Foundation
import RiveRuntime

class RiveManager: ObservableObject {
    static let shared = RiveManager()
    
    @Published var riveModel: RiveViewModel
    
    private init() {
        // Inicializamos con un archivo Rive por defecto.
        self.riveModel = RiveViewModel(fileName: "melody", stateMachineName: "Actions", artboardName: "inGameAB")
    }

    // Método para actualizar los inputs en el modelo Rive.
    func setInput(_ name: String, value: Double) {
        riveModel.setInput(name, value: value)
    }

    // Método para actualizar el archivo Rive según el avatar seleccionado.
    func updateRiveModel(for avatarName: String) {
        let fileName: String
        
        switch avatarName {
        case "avatar1":
            fileName = "molly"
        case "avatar2":
            fileName = "monin"
        case "avatar3":
            fileName = "melody"
        case "avatar4":
            fileName = "Jacobo"
        case "avatar5":
            fileName = "jack"
        default:
            fileName = "melody"
        }
        
        self.riveModel = RiveViewModel(fileName: fileName, stateMachineName: "Actions", artboardName: "inGameAB")
    }
}
