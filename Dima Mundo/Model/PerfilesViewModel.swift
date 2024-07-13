//
//  PerfilesViewModel.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 02/07/24.
//

import Foundation
import CoreData

class PerfilesViewModel: ObservableObject {
    @Published var perfiles: [Perfil] = []
    
    init() {
        cargarPerfiles()
    }
    
    func cargarPerfiles() {
        let fetchRequest: NSFetchRequest<Perfil> = Perfil.fetchRequest()
        do {
            let resultado = try DataManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
            self.perfiles = resultado
        } catch let error as NSError {
            print("Error al cargar perfiles: \(error), \(error.userInfo)")
        }
    }
}
