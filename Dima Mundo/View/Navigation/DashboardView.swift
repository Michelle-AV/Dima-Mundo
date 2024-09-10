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
    
    @State var isTappedPicker: Bool = true
    @State var isEjercicios: Bool = false
    
    @State var isDateSorted: Bool = false
    @State var isUsernameSorted: Bool = false
    
    @State var opacityRows: Double = 1.0
    
    enum SortColumn {
        case usuario, aciertos, errores, fecha
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: appData.UISW * 0.9, height: appData.UISH * 0.8)
                .padding(.top, appData.UISH * 0.1)

            ZStack {
                // Encabezado
                HStack {
                    Button(action: {
                        withAnimation (.smooth(duration: 0.1)){
                            isShowingHistorial = false
                        }
                    }) {
                        Text("Gestionar perfiles")
                            .font(.custom("RifficFree-Bold", size: 20))
                            .foregroundColor(isShowingHistorial ? Color.skinMonin : .white)
                            .frame(width: appData.UISW * 0.2, height: appData.UISH * 0.07)
                            .background(
                                ZStack {
                                    if isShowingHistorial {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.skinMonin, lineWidth: 3)
                                            .background(Color.clear)
                                    } else {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.skinMonin)
                                            .stroke(Color.skinMonin, lineWidth: 3)
                                    }
                                }
                            )
                    }
                    
                    Spacer()
                    
                    Text("Panel de control")
                        .font(.custom("RifficFree-Bold", size: 35))
                        .foregroundColor(Color.skinMonin)

                    Spacer()


                    Button(action: {
                        withAnimation (.smooth(duration: 0.1)){
                            isShowingHistorial = true
                        }
                        if isShowingHistorial {
                            ejercicios = fetchEjercicios()
                        }
                    }) {
                        Text("Historial")
                            .font(.custom("RifficFree-Bold", size: 20))
                            .foregroundColor(!isShowingHistorial ? Color.skinMonin : .white)
                            .frame(width: appData.UISW * 0.2, height: appData.UISH * 0.07)
                            .background(
                                ZStack {
                                    if !isShowingHistorial {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.skinMonin, lineWidth: 3)
                                            .background(Color.clear)
                                    } else {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.skinMonin)
                                            .stroke(Color.skinMonin, lineWidth: 3)
                                    }
                                }
                            )
                    }
                }.offset(y: appData.UISH * -0.27)
                .padding(.top, 40)

                if isShowingHistorial {
                    historialView
                        .offset(y: appData.UISH * 0.12)
                } else {
                    gestionarPerfilesView
                        .offset(y: appData.UISH * 0.12)
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
        ScrollView (showsIndicators: false){
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
        .frame(width: appData.UISW * 0.8, height: appData.UISH * 0.58)
        .background(RoundedRectangle(cornerRadius: 25).fill(Color.CelesteBG))
    }

    // Vista para mostrar el historial
    private var historialView: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(Color.CelesteBG)
                .frame(height: appData.UISH * 0.58)
            
            VStack {
                // Filtros y ordenamiento
                HStack{
                    Button("Graficar") {
                        // Acción para graficar
                    }
                    .font(.custom("RifficFree-Bold", size: 20))
                    .foregroundColor(.white)
//                    .frame(width: appData.UISW * 0.15, height: appData.UISH * 0.05)
                    .frame(width: 150, height: 50)
                    .background(Color.VerdeAns)
                    .cornerRadius(10)
                    .padding(.leading, 12)
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.CelesteBtnDash)
                        
                        HStack {
                            Text("\(filterType)")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .foregroundColor(.white)
                                .padding(.leading, 40)
                            
                            Spacer()
                            
                            Image(systemName: "triangle.fill")
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(!isTappedPicker ? 0 : 180))
                                .padding(.trailing, 30)
                        }
                        
                    }.frame(width: isEjercicios ? 200 : 150, height: 50)
                        .onTapGesture {
                            withAnimation (.smooth(duration: 0.3)){
                                isTappedPicker.toggle()
                            }
                        }
                        .padding(.trailing, 12)
                    
//                    // Filtro por tipo de ejercicio
//                    Picker(selection: $filterType, label: Text("")) {
//                        Text("Reto").tag("Reto")
//                        Text("Ejercicio").tag("Ejercicio")
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                    .frame(width: appData.UISW * 0.2)
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                    .onChange(of: filterType) { _ in
//                        ejercicios = fetchEjercicios()
//                    }
                }
                .padding(.horizontal)
                .offset(y: -20)

                // Tabla de historial
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.white)
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(ejercicios, id: \.ejercicioID) { ejercicio in
                                historialRow(ejercicio)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 0)
                        .offset(x: 74)
                    }
                    .frame(width: appData.UISW * 0.7, height: 250)
                    .clipped()
                    .offset(y: 40)

                    
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.white)
                        .frame(height: 90)
                        .offset(y: -132)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.CelesteBtnDash)
                        HStack {
                            Text("Usuario")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .foregroundColor(.white)
                            
                            Image(systemName: "triangle.fill")
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(isUsernameSorted ? 0 : 180)) // Rotar la flecha
                        }
                    }.frame(width: 150, height: 50)
                        .position(x: appData.UISW * 0.08, y: appData.UISH * 0.06)
                        .onTapGesture {
                            opacityRows = 0.1
                            withAnimation (.spring(duration: 0.3)){
                                isUsernameSorted.toggle() // Cambiar el valor para invertir el orden
                                sortColumn = .usuario // Establecer la columna de orden como usuario
                                if isUsernameSorted {
                                    isDateSorted = false
                                }
                                ejercicios = fetchEjercicios() // Refrescar la lista de ejercicios
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    opacityRows = 1
                                }
                            }
                        }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.CelesteBtnDash)
                        HStack {
                            Text("Aciertos")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .foregroundColor(.white)
                        }
                    }.frame(width: 150, height: 50)
                        .position(x: appData.UISW * 0.26, y: appData.UISH * 0.06)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.CelesteBtnDash)
                        HStack {
                            Text("Errores")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .foregroundColor(.white)
                        }
                    }.frame(width: 150, height: 50)
                        .position(x: appData.UISW * 0.46, y: appData.UISH * 0.06)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.CelesteBtnDash)
                        HStack (spacing: 15){
                            Text("Fecha")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .foregroundColor(.white)
                                                    
                            Image(systemName: "triangle.fill")
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(isDateSorted ? 0 : 180))
                        }
                    }.frame(width: 150, height: 50)
                        .position(x: appData.UISW * 0.67, y: appData.UISH * 0.06)
                        .onTapGesture {
                            opacityRows = 0.1
                            withAnimation (.spring(duration: 0.3)){
                                isDateSorted.toggle()
                                if isDateSorted {
                                    isUsernameSorted = false
                                }
                                sortColumn = .fecha
                                ejercicios = fetchEjercicios()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    opacityRows = 1
                                }
                            }
                        }
                    
                }.frame(width: appData.UISW * 0.75, height: appData.UISH * 0.43)
                
                
    //            HStack {
    //                headerColumn(title: "Usuario", column: .usuario)
    //                headerColumn(title: "Aciertos", column: .aciertos)
    //                headerColumn(title: "Errores", column: .errores)
    //                headerColumn(title: "Fecha", column: .fecha)
    //            }
    //            .position(x: appData.UISW * 0.45)
    //            .padding(.vertical)
    //            .background(RoundedRectangle(cornerRadius: 25).fill(Color.CelesteBG))
                
            }.offset(y: 10)
            
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.CelesteBtnDash)
                    .opacity(isTappedPicker ? 0 : 1)
                
                RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.white)
                        .frame(height: 3)
                        .opacity(isTappedPicker ? 0 : 1)
                
                HStack(spacing: 20){
                    Image(systemName: filterType == "Reto" ? "checkmark.square.fill" : "square")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 20)
                    
                    Text("Reto")
                        .font(.custom("RifficFree-Bold", size: 20))
                        .foregroundColor(.white)
                }.offset(x: -23,y: -30)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.2)) {
                            isEjercicios = false
                        }
                        filterType = "Reto"
                        ejercicios = fetchEjercicios()
                    }
                    .opacity(isTappedPicker ? 0 : 1)
                
                
                HStack(spacing: 20){
                    Image(systemName: filterType == "Ejercicio" ? "checkmark.square.fill" : "square")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 20)
                    
                    Text("Ejercicio")
                        .font(.custom("RifficFree-Bold", size: 20))
                        .foregroundColor(.white)
                }.offset(y: 30)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.2)) {
                            isEjercicios = true
                        }
                        filterType = "Ejercicio"
                        ejercicios = fetchEjercicios()
                    }
                    .opacity(isTappedPicker ? 0 : 1)
                
            }.frame(width: isTappedPicker ? 0 : 200, height: isTappedPicker ? 0 : 130)
                .position(x: appData.UISW * 0.69, y: appData.UISH * 0.18)
                .offset(x: isTappedPicker ? 50 : 0, y: !isTappedPicker ? 0 : -70)
            
        }
        .onAppear{
            ejercicios = fetchEjercicios()
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
                .offset(x: 25)
            
            Text("\(ejercicio.errores)")
                .font(.custom("RifficFree-Bold", size: 20))
                .frame(width: appData.UISW * 0.2, alignment: .leading)
                .offset(x: 20)
            
            Text(formatDate(ejercicio.fecha))
                .font(.custom("RifficFree-Bold", size: 20))
                .frame(width: appData.UISW * 0.2, alignment: .leading)
            
        }.foregroundColor(Color.skinMonin)
            .opacity(opacityRows)
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
            fetchedEjercicios.sort {
                if isUsernameSorted {
                    return ($0.perfil?.nombre ?? "") > ($1.perfil?.nombre ?? "")
                } else {
                    return ($0.perfil?.nombre ?? "") < ($1.perfil?.nombre ?? "")
                }
            }
        case .aciertos:
            fetchedEjercicios.sort { sortAscending ? $0.aciertos < $1.aciertos : $0.aciertos > $1.aciertos }
        case .errores:
            fetchedEjercicios.sort { sortAscending ? $0.errores < $1.errores : $0.errores > $1.errores }
        case .fecha:
            fetchedEjercicios.sort {
                if isDateSorted {
                    return $0.fecha ?? Date() > $1.fecha ?? Date()
                } else {
                    return $0.fecha ?? Date() < $1.fecha ?? Date()
                }
            }
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
