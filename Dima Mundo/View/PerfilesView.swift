//
//  PerfilesView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 02/07/24.
//
import SwiftUI

struct PerfilesView: View {
    @ObservedObject var viewModel = PerfilesViewModel()
    @State private var selectedPerfil: Perfil?
    @State private var showCrearPerfil = false
    
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color.purple.opacity(0.7).edgesIgnoringSafeArea(.all)
            Fondo()
            Text("¿Quién eres?")
                .font(.custom("RifficFree-Bold", size: 83))
                .foregroundColor(.white)
                .position(x: UISW * 0.5, y: UISH * 0.19)
            
            HStack {
                ForEach(viewModel.perfiles, id: \.objectID) { perfil in
                    perfilView(perfil)
                }
            }
            
            if selectedPerfil != nil {
                Button("Continuar") {
                    print("Continuar con perfil seleccionado")
                }
                .font(.custom("RifficFree-Bold", size: 30))
                .foregroundColor(.white)
                .padding()
                .background(Color.purple)
                .cornerRadius(10)
                .position(x: UISW * 0.5, y: UISH * 0.8)
            }
            
            NavigationLink(destination: CrearPerfilView()) {
                Image("other")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .foregroundColor(.blue)
            }
            .position(x: UISW * 0.08, y: UISH * 0.80)
            
            // MARK: -Borrar cuando la vista esté terminada
            Button("X") {
                DataManager.shared.deleteAllPerfiles()
                viewModel.cargarPerfiles()  // Recargar perfiles tras la eliminación
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
            .opacity(1)
            .position(x: UISW * 0.88, y: UISH * 0.80)
            
            Image("referencia")
                .resizable()
                .scaledToFit()
                .opacity(0)
            
        }
            
        
        
    }
    
    
    //MARK: - La plantilla de como se ve cada perfil - las animaciones no van bien
    
    func perfilView(_ perfil: Perfil) -> some View {
        VStack {
            Image(uiImage: UIImage(named: perfil.avatarNombre ?? "default_avatar") ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: selectedPerfil == perfil ? 300 : 200)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 0)
                )
                .overlay(
                    Group {
                        if selectedPerfil == perfil {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 90)
                                .overlay(
                                    Text("\(perfil.ejerciciosCompletados)")
                                        .font(.custom("RifficFree-Bold", size: 20))
                                        .foregroundColor(.black)
                                )
                                .position(x: 60, y: 260) // Adjust as needed
                        }
                    }
                )
                .onTapGesture {
                    selectedPerfil = (selectedPerfil == perfil ? nil : perfil)
                }
            Text(perfil.nombre ?? "Desconocido")
                .font(.custom("RifficFree-Bold", size: selectedPerfil == perfil ? 60 : 40))
                .foregroundColor(.white)
        }
        .animation(.snappy(duration: 0.35), value: selectedPerfil)
        .padding()
    }
}

#Preview{
    PerfilesView()
}
