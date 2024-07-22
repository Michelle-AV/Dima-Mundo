//
//  DataManager.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 02/07/24.
//

import CoreData
import UIKit

class DataManager {
    static let shared = DataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func addPerfil(nombre: String, avatarNombre: String) {
        let context = persistentContainer.viewContext
        let perfil = Perfil(context: context)
        perfil.id = UUID()
        perfil.nombre = nombre
        perfil.ejerciciosCompletados = 0
        perfil.avatarNombre = avatarNombre
        saveContext()
    }

    func addEjercicio(to perfil: Perfil, nivel: Int, cantidad: Int) {
        let context = persistentContainer.viewContext
        let ejercicio = Ejercicio(context: context)
        ejercicio.setValue(cantidad, forKey: "N\(nivel)")
        ejercicio.perfil = perfil
        perfil.ejerciciosCompletados += Int16(cantidad)
        saveContext()
    }
    
    func incrementEjerciciosCompletados(for perfil: Perfil) {
        let context = persistentContainer.viewContext
        perfil.ejerciciosCompletados += 1
        saveContext()
    }
    
    func deleteAllPerfiles() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Perfil.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            print("Error al borrar todos los perfiles: \(error), \(error.userInfo)")
        }
    }
}
