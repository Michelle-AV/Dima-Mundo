//
//  EditProfilView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 17/08/24.
//
import SwiftUI

struct EditProfileView: View {
    @Binding var isPresented: Bool
    @State var name: String
    @State var avatar: String
    @State private var showAvatarSelection = false
    var onSave: (String, String) -> Void // Función callback para guardar los cambios

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Creado el 03/08/2024")
                    .font(.custom("RifficFree-Bold", size: 20))
                    .foregroundColor(Color.gray)

                Image(avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 190, height: 190)
                    .onTapGesture {
                        withAnimation (.smooth(duration: 0.3)){
                            showAvatarSelection.toggle()

                        }
                    }

                TextField("Nombre", text: $name)
                    .font(.custom("RifficFree-Bold", size: 28))
                    .foregroundColor(Color.skinMonin)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)

                Button(action: {
                    onSave(name, avatar)
                    isPresented = false
                }) {
                    Text("Guardar")
                        .font(.custom("RifficFree-Bold", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
            .frame(width: 300, height: 350)
            

            // Popup de selección de avatar
            if showAvatarSelection {
                AvatarSelectionView(selectedAvatar: $avatar, isPresented: $showAvatarSelection)
                    /*.transition(.move(edge: .bottom))*/ // Transición de movimiento desde abajo
                    .offset(y: -50)                    // Desplazamiento opcional si lo necesitas
            }
        }
    }
}

struct AvatarSelectionView: View {
    @Binding var selectedAvatar: String
    @Binding var isPresented: Bool

    let avatars = ["avatar1", "avatar2", "avatar3", "avatar4", "avatar5"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Cambiar dima-amigo")
                .font(.custom("RifficFree-Bold", size: 30))
                .foregroundColor(Color.skinMonin)

            HStack(spacing: 20) {
                ForEach(avatars, id: \.self) { avatar in
                    Image(avatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .onTapGesture {
                            selectedAvatar = avatar
                            isPresented = false
                        }
                }
            }
        }.frame(width: 500, height: 160)
            .fixedSize()
            .layoutPriority(1)
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.CelesteBG))
    }
}

#Preview {
    EditProfileView(isPresented: .constant(true), name: "Michelle", avatar: "avatar2") { newName, newAvatar in
        // Handle the saving logic
        print("Nuevo nombre: \(newName), Nuevo avatar: \(newAvatar)")
    }
}

