//
//  DashboardView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 17/08/24.
//
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appData: AppData
    @Binding var isLoggedIn: Bool

    @State private var perfiles: [Perfil] = []
    @State private var selectedPerfil: Perfil?
    @State private var showEditProfile = false
    @State private var isShowingHistorial = false
    @State private var ejercicios: [Ejercicio] = []
    @State private var filterType: String = "Reto" // Valores posibles: "Reto", "Ejercicio"
    @State private var sortColumn: SortColumn = .fecha
    @State private var sortAscending: Bool = true

    enum SortColumn {
        case usuario, aciertos, errores, fecha
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: appData.UISW * 0.9, height: appData.UISH * 0.8)
                .padding(.top, appData.UISH * 0.1)

            VStack(spacing: 50) {
                // Encabezado
                HStack {
                    Button(action: {
                        isShowingHistorial = false
                    }) {
                        Text("Gestionar perfiles")
                            .font(.custom("RifficFree-Bold", size: 20))
                            .foregroundColor(.white)
                            .frame(width: appData.UISW * 0.2, height: appData.UISH * 0.07)
                            .background(isShowingHistorial ? Color.gray : Color.skinMonin)
                            .cornerRadius(15)
                    }
                    
                    Spacer()
                    
                    Text("Panel de control")
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(Color.skinMonin)

                    Spacer()

                    Button(action: {
                        isShowingHistorial.toggle()
                        if isShowingHistorial {
                            ejercicios = fetchEjercicios()
                        }
                    }) {
                        Text("Historial")
                            .font(.custom("RifficFree-Bold", size: 20))
                            .padding(10)
                            .foregroundColor(isShowingHistorial ? .white : .skinMonin)
                            .frame(width: appData.UISW * 0.2, height: appData.UISH * 0.07)
                            .background(isShowingHistorial ? Color.skinMonin : Color.clear)
                            .cornerRadius(15)
                    }
                }
                .padding(.top, 40)

                if isShowingHistorial {
                    historialView
                } else {
                    gestionarPerfilesView
                }
            }
            .frame(width: appData.UISW * 0.8, height: appData.UISH * 0.6)
            .onAppear {
                perfiles = DataManager.shared.fetchPerfiles()
            }

            // Popup para editar perfil
            if let perfil = selectedPerfil, showEditProfile {
                EditProfileView(isPresented: $showEditProfile, name: perfil.nombre ?? "", avatar: perfil.avatarNombre ?? "avatar") { newName, newAvatar in
                    updatePerfil(perfil, newName: newName, newAvatar: newAvatar)
                }
                .transition(.scale)
            }
        }
    }

    // Vista para gestionar perfiles
    private var gestionarPerfilesView: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(perfiles, id: \.id) { perfil in
                    ProfileRow(perfil: perfil, onEdit: {
                        selectedPerfil = perfil
                        showEditProfile = true
                    }, onDelete: {
                        deletePerfil(perfil)
                    })
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .frame(width: appData.UISW * 0.8, height: appData.UISH * 0.5)
        .background(RoundedRectangle(cornerRadius: 25).fill(Color.CelesteBG))
    }

    // Vista para mostrar el historial
    private var historialView: some View {
        VStack {
            // Filtros y ordenamiento
            HStack {
                Button("Graficar") {
                    // Acción para graficar
                }
                .font(.custom("RifficFree-Bold", size: 20))
                .foregroundColor(.white)
                .frame(width: appData.UISW * 0.15, height: appData.UISH * 0.05)
                .background(Color.green)
                .cornerRadius(10)
                
                Spacer()

                // Filtro por tipo de ejercicio
                Picker(selection: $filterType, label: Text("")) {
                    Text("Reto").tag("Reto")
                    Text("Ejercicio").tag("Ejercicio")
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: appData.UISW * 0.2)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .onChange(of: filterType) { _ in
                    ejercicios = fetchEjercicios()
                }
            }
            .padding(.horizontal)

            // Tabla de historial
            HStack {
                headerColumn(title: "Usuario", column: .usuario)
                headerColumn(title: "Aciertos", column: .aciertos)
                headerColumn(title: "Errores", column: .errores)
                headerColumn(title: "Fecha", column: .fecha)
            }
            .position(x: appData.UISW * 0.45)
            .padding(.vertical)
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.CelesteBG))

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(ejercicios, id: \.ejercicioID) { ejercicio in
                        historialRow(ejercicio)
                    }
                }
                .padding(.top, 60)
                .position(x: appData.UISW * 0.45)
                
            }
            .frame(width: appData.UISW * 0.8, height: appData.UISH * 0.4)
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.CelesteBG))
            
        }
    }

    // Columna de encabezado de tabla con ordenamiento
    private func headerColumn(title: String, column: SortColumn) -> some View {
        Button(action: {
            if sortColumn == column {
                sortAscending.toggle()
            } else {
                sortColumn = column
                sortAscending = true
            }
            ejercicios = fetchEjercicios()
        }) {
            HStack {
                Text(title)
                    .font(.custom("RifficFree-Bold", size: 20))
                    .foregroundColor(Color.blue)
                if sortColumn == column {
                    Image(systemName: sortAscending ? "arrow.up" : "arrow.down")
                }
            }
        }
        .frame(width: appData.UISW * 0.2, alignment: .leading)
    }

    // Fila de historial
    private func historialRow(_ ejercicio: Ejercicio) -> some View {
        HStack {
            Text(ejercicio.perfil?.nombre ?? "Desconocido")
                .font(.custom("RifficFree-Bold", size: 20))
                .frame(width: appData.UISW * 0.2, alignment: .leading)
            
            Text("\(ejercicio.aciertos)")
                .font(.custom("RifficFree-Bold", size: 20))
                .frame(width: appData.UISW * 0.2, alignment: .leading)
            
            Text("\(ejercicio.errores)")
                .font(.custom("RifficFree-Bold", size: 20))
                .frame(width: appData.UISW * 0.2, alignment: .leading)
            
            Text(formatDate(ejercicio.fecha))
                .font(.custom("RifficFree-Bold", size: 20))
                .frame(width: appData.UISW * 0.2, alignment: .leading)
        }
        .padding(.vertical, 5)
    }

    // Formatear la fecha en un formato legible
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Desconocido" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }

    // Obtener ejercicios con filtros y ordenamiento
    private func fetchEjercicios() -> [Ejercicio] {
        var fetchedEjercicios = DataManager.shared.fetchAllEjercicios().filter { $0.tipo == filterType }

        switch sortColumn {
        case .usuario:
            fetchedEjercicios.sort { (sortAscending ? $0.perfil?.nombre ?? "" < $1.perfil?.nombre ?? "" : $0.perfil?.nombre ?? "" > $1.perfil?.nombre ?? "") }
        case .aciertos:
            fetchedEjercicios.sort { sortAscending ? $0.aciertos < $1.aciertos : $0.aciertos > $1.aciertos }
        case .errores:
            fetchedEjercicios.sort { sortAscending ? $0.errores < $1.errores : $0.errores > $1.errores }
        case .fecha:
            fetchedEjercicios.sort { sortAscending ? $0.fecha ?? Date() < $1.fecha ?? Date() : $0.fecha ?? Date() > $1.fecha ?? Date() }
        }

        return fetchedEjercicios
    }

    // Actualizar perfil
    func updatePerfil(_ perfil: Perfil, newName: String, newAvatar: String) {
        DataManager.shared.updatePerfil(perfil, newName: newName, newAvatar: newAvatar)
        perfiles = DataManager.shared.fetchPerfiles()
    }

    // Eliminar perfil
    func deletePerfil(_ perfil: Perfil) {
        DataManager.shared.deletePerfil(perfil)
        perfiles = DataManager.shared.fetchPerfiles()
    }
}

// Vista para una fila de perfil
struct ProfileRow: View {
    var perfil: Perfil
    var onEdit: () -> Void
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            Image(perfil.avatarNombre ?? "avatar")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .foregroundColor(Color.yellow)

            VStack(alignment: .leading) {
                Text(perfil.nombre ?? "Sin Nombre")
                    .font(.custom("RifficFree-Bold", size: 30))
                    .foregroundColor(Color.skinMonin)

                Text("Creado el \(formatDate(perfil.fechaCreacion))")
                    .font(.custom("RifficFree-Bold", size: 20))
                    .foregroundColor(Color.gray)
            }

            Spacer()

            Text("Intentos: \(perfil.ejerciciosCompletados)")
                .font(.custom("RifficFree-Bold", size: 20))
                .foregroundColor(Color.gray)

            Button(action: onEdit) {
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .foregroundColor(.blue)
            }

            Button(action: onDelete) {
                Image(systemName: "trash.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
    }
    
    // Formatear la fecha en un formato legible
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Desconocido" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    DashboardView(isLoggedIn: .constant(true))
        .environmentObject(AppData())
}
