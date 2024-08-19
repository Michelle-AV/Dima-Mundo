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

    func saveContext() {
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

    // MARK: - Add Perfil
    func addPerfil(nombre: String, avatarNombre: String) {
        let context = persistentContainer.viewContext
        let perfil = Perfil(context: context)
        perfil.id = UUID()
        perfil.nombre = nombre
        perfil.avatarNombre = avatarNombre
        perfil.ejerciciosCompletados = 0
        perfil.fechaCreacion = Date() // Registrar la fecha y hora de creación
        saveContext()
    }

    // MARK: - Add Ejercicio
    func addEjercicio(to perfil: Perfil, aciertos: Int16, errores: Int16, tabla: Int16, tipo: String) {
        let context = persistentContainer.viewContext
        let ejercicio = Ejercicio(context: context)
        
        ejercicio.ejercicioID = UUID()
        ejercicio.aciertos = aciertos
        ejercicio.errores = errores
        ejercicio.tabla = tabla
        ejercicio.tipo = tipo
        ejercicio.fecha = Date()
        ejercicio.perfil = perfil // Relacionar el ejercicio con el perfil

        // Incrementar el contador de ejercicios completados en el perfil        
        saveContext()
    }

    // MARK: - Incrementar Ejercicios Completados
    func incrementEjerciciosCompletados(for perfil: Perfil) {
        let context = persistentContainer.viewContext
        perfil.ejerciciosCompletados += 1
        saveContext()
    }

    // MARK: - Fetch Perfiles
    func fetchPerfiles() -> [Perfil] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Perfil> = Perfil.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error al obtener los perfiles: \(error)")
            return []
        }
    }

    // MARK: - Fetch Ejercicios
    func fetchEjercicios(for perfil: Perfil) -> [Ejercicio] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Ejercicio> = Ejercicio.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "perfil == %@", perfil)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error al obtener los ejercicios: \(error)")
            return []
        }
    }
    
    // MARK: - Fetch All Ejercicios
    func fetchAllEjercicios() -> [Ejercicio] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Ejercicio> = Ejercicio.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error al obtener todos los ejercicios: \(error)")
            return []
        }
    }

    // MARK: - Update Perfil
    func updatePerfil(_ perfil: Perfil, newName: String, newAvatar: String) {
        let context = persistentContainer.viewContext
        perfil.nombre = newName
        perfil.avatarNombre = newAvatar
        saveContext()
    }

    // MARK: - Delete Perfil
    func deletePerfil(_ perfil: Perfil) {
        let context = persistentContainer.viewContext
        context.delete(perfil)
        saveContext()
    }
    
    // MARK: - Delete All Perfiles
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
