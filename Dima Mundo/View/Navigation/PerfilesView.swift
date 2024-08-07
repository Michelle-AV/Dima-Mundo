//
//  PerfilesView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 02/07/24.
//
// MARK: - Probablemente ocupe separar PerfilesView y perfilView en archivos y renombrar a PerfilSelectorManager al momento de agregar los audios
import SwiftUI

struct PerfilesView: View {
    @EnvironmentObject var appData: AppData
    @ObservedObject var viewModel = PerfilesViewModel()
    @State private var selectedPerfil: Perfil?
    @State private var showCrearPerfil = false
    @State private var expandButton = false
    @State private var circleScale: CGFloat = 0.001
    @State private var showSelectTableView = false
    @StateObject private var riveModel = RiveModel()
    
    var onHome: () -> Void

    var body: some View {
        ZStack {
            if showSelectTableView {
                if let selectedPerfil = selectedPerfil {
                    SelectTableView(
                        selectedAvatar: selectedPerfil.avatarNombre ?? "default_avatar",
                        perfilName: selectedPerfil.nombre ?? "Desconocido",
                        perfil: $viewModel.perfiles[viewModel.perfiles.firstIndex(where: { $0.id == selectedPerfil.id })!],
                        showSelectTableView: $showSelectTableView,
                        riveModel: riveModel
                    )
                    .environmentObject(appData)
                    .transition(.move(edge: .trailing))
                }
            } else {
                perfilesContent
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.bouncy, value: showSelectTableView)
        .onAppear {
            if let selectedPerfil = selectedPerfil {
                updateRiveModel(for: selectedPerfil.avatarNombre ?? "default_avatar")
            }
        }
    }
    
    var perfilesContent: some View {
        ZStack {
            Color.MoradoFondo.edgesIgnoringSafeArea(.all)
            FondoCP()
            Text("¿Quién eres?")
                .font(.custom("RifficFree-Bold", size: 83))
                .foregroundColor(.white)
                .position(x: appData.UISW * 0.5, y: appData.UISH * 0.19)
            
            HStack {
                ForEach(viewModel.perfiles, id: \.objectID) { perfil in
                    perfilView(perfil)
                }
            }
            .frame(width: appData.UISW, height: appData.UISH, alignment: .center)
            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.49)

            
            
            if selectedPerfil != nil {
                Button("Continuar") {
                    updateRiveModel(for: selectedPerfil!.avatarNombre ?? "default_avatar")
                    showSelectTableView = true
                }
                .font(.custom("RifficFree-Bold", size: 30))
                .foregroundColor(.white)
                .padding()
                .background(Color.MoradoBtn)
                .cornerRadius(10)
                .position(x: appData.UISW * 0.5, y: appData.UISH * 0.8)
            }
            
            Button(action: {
   //             DataManager.shared.deleteAllPerfiles()
                viewModel.cargarPerfiles()
                withAnimation(.easeInOut(duration: 0.55)) {
                    expandButton = true
                    circleScale = expandButton ? 3 : 0.001
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.easeInOut(duration: 0.45)) {
                        showCrearPerfil = true
                    }
                }
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: expandButton ? 0 : 40)

            }
            .frame(width: expandButton ? 0 : 40)
            .padding(10)
            .background(expandButton ? Color.Azul : Color.MoradoBtn)
            .cornerRadius(15)
            .position(x: appData.UISW * 0.1, y: appData.UISH * 0.80)
            .zIndex(2)
            
            if expandButton {
                Circle()
                    .fill(Color.Azul)
                    .frame(width: appData.UISW * 2, height: appData.UISH * 2)
                    .scaleEffect(circleScale)
                    .position(x: appData.UISW * 0.1, y: appData.UISH * 0.80)
                    .animation(.bouncy(duration: 0.5), value: circleScale)
                    .transition(.scale)
            }

            if showCrearPerfil {
                CrearPerfilView(onSave: {
                    viewModel.cargarPerfiles()
                    withAnimation(.easeInOut(duration: 0)) {
                        showCrearPerfil.toggle()
                        expandButton.toggle()
                        circleScale = 0.001
                    }
                }, onCancel: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showCrearPerfil = false
                        expandButton = false
                        circleScale = 3
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            circleScale = 0.001
                        }
                    }
                })
                .transition(.opacity)
                .zIndex(2)
                .mask(
                    Circle()
                        .scale(circleScale)
                        .frame(width: appData.UISW * 2, height: appData.UISH * 2)
                        .position(x: appData.UISW * 0.1, y: appData.UISH * 0.80)
                        .animation(.easeInOut(duration: 0.5), value: circleScale)
                )
            }

            // Botón de "Home"
            Button(action: onHome) {
                Image("inicio")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .foregroundColor(.white)
            }
            .position(x:appData.UISW * 0.1, y: appData.UISH * 0.1)
                    
                
            
        }
    }
    
    func perfilView(_ perfil: Perfil) -> some View {
        VStack {
            Image(uiImage: UIImage(named: perfil.avatarNombre ?? "default_avatar") ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: selectedPerfil == perfil ? 180 : 120)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 0)
                )
                .overlay(
                    Group {
                        if (selectedPerfil == perfil) {
                            Circle()
                                .fill(Color.MoradoCount)
                                .frame(width: 75)
                                .overlay(
                                    Text("\(perfil.ejerciciosCompletados)")
                                        .font(.custom("RifficFree-Bold", size: 30))
                                        .foregroundColor(.white)
                                )
                                .position(x: 40, y: 160)
                        }
                    }
                )
                .onTapGesture {
                    selectedPerfil = (selectedPerfil == perfil ? nil : perfil)
                }
            Text(perfil.nombre ?? "Desconocido")
                .font(.custom("RifficFree-Bold", size: (selectedPerfil == perfil ? 60 : 40)))
                .foregroundColor(.white)
        }
        .animation(.snappy(duration: 0.35), value: selectedPerfil)
        .padding()
    }
    
    func updateRiveModel(for avatarName: String) {
        switch avatarName {
        case "avatar1":
            riveModel.fileName = "molly"
        case "avatar2":
            riveModel.fileName = "monin"
        case "avatar3":
            riveModel.fileName = "melody"
        case "avatar4":
            riveModel.fileName = "pablo"
        case "avatar5":
            riveModel.fileName = "jack3"
        default:
            riveModel.fileName = "jack3"
        }
    }
}

#Preview {
    PerfilesView(onHome: {})
        .environmentObject(AppData())
}
