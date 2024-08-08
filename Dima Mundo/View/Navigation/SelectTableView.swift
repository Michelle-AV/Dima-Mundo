//
//  selectNumberView.swift
//  Dima Mundo
//
//  Created by Pedro Prado on 12/07/24.

// MARK: - selectTableView utiliza CardModel.swift, CardView.swift
import SwiftUI
import RiveRuntime

struct SelectTableView: View {
    @EnvironmentObject var appData: AppData
    @State private var currentIndex: Int = 0
    @State private var selectedCard: Int? = nil
    @State private var isExpanded = false
    @State var Exercise: Bool = false
    @State var Tabla: Int = 0

    var selectedAvatar: String
    var perfilName: String
    @Binding var perfil: Perfil
    @Binding var showSelectTableView: Bool
    @ObservedObject var riveModel: RiveModel
    @Namespace private var animation
    @State var sound: Bool = true


    let cards = [
        Card(id: 0, label: "Uno", imageName: "tabla1"),
        Card(id: 1, label: "Dos", imageName: "tabla2"),
        Card(id: 2, label: "Tres", imageName: "tabla3"),
        Card(id: 3, label: "Cuatro", imageName: "tabla4"),
        Card(id: 4, label: "Cinco", imageName: "tabla5"),
        Card(id: 5, label: "Seis", imageName: "tabla6"),
        Card(id: 6, label: "Siete", imageName: "tabla7"),
        Card(id: 7, label: "Ocho", imageName: "tabla8"),
        Card(id: 8, label: "Nueve", imageName: "tabla9"),
        Card(id: 9, label: "Diez", imageName: "tabla10"),
        Card(id: 10, label: "Once", imageName: "tablaReto")
    ]

    var body: some View {
        ZStack {
            Image("elegir-tabla-fondo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ZStack {
                // MARK: - Header
                ZStack {
                    Text("Elige una tabla para practicar")
                        .font(.custom("RifficFree-Bold", size: 50))
                        .foregroundColor(.white)
                        .position(CGPoint(x: appData.UISW * 0.5, y: appData.UISH * 0.1))

                    if !isExpanded {
                        profileHeader
                            .matchedGeometryEffect(id: "profileHeader", in: animation)
                    }
                    
                    Button{
                        withAnimation(.easeInOut(duration: 0.1)) {
                            sound.toggle()
                        }
                    } label: {
                        Image(sound ? "sound" : "mute")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                           
                    }.position(x: appData.UISW * 0.94, y: appData.UISH * 0.09)

                    
                    // Rive animation for avatar
                    RiveViewModel(fileName: riveModel.fileName, stateMachineName: "Actions", artboardName: "walkingAB").view()
                        .id(riveModel.fileName)
                        .scaleEffect(0.6)
                        .allowsHitTesting(false)
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.84)
                }

                // MARK: - Carrusel
                ZStack {
                    Button(action: {
                        previousSection()
                    }) {
                        Image("left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                    }
                    .disabled(currentIndex == 0)
                    .position(x: appData.UISW * 0.1, y: appData.UISH * 0.5)

                    HStack(spacing: 40) {
                        ForEach(currentCards(), id: \.id) { card in
                            CardView(Exercise: $Exercise, Tabla: $Tabla, card: card, isSelected: selectedCard == card.id, incrementExercises: incrementExercises)
                                .onTapGesture {
                                    selectCard(card.id)
                                }
                        }
                    }
                    .animation(.bouncy, value: currentIndex)
                    .frame(width: appData.UISW, height: appData.UISH, alignment: .center)
                    .position(x: appData.UISW * 0.5, y: appData.UISH * 0.45)

                    Button(action: {
                        nextSection()
                    }) {
                        Image("right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                    }
                    .disabled(currentIndex == totalSections() - 1)
                    .position(x: appData.UISW * 0.9, y: appData.UISH * 0.5)
                }
            }

            if isExpanded {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation (.easeInOut (duration: 0)) {
                            isExpanded = false
                        }
                    }

                expandedProfileView
                    .matchedGeometryEffect(id: "profileHeader", in: animation)
            }
            
            if(Exercise && Tabla < 11){
                // Passing riveModel to TablesExView
                TablesExView(table: $Tabla, back: $Exercise, riveModel: riveModel, selectedAvatar: selectedAvatar, incrementExercises: incrementExercises)
                    .frame(width: appData.UISW, height: appData.UISH)
                    .ignoresSafeArea()
                    
            }else if(Exercise && Tabla == 11){
                RetoView(back: $Exercise, riveModel: riveModel, selectedAvatar: selectedAvatar, incrementExercises: incrementExercises)
                    .frame(width: appData.UISW, height: appData.UISH)
                    .ignoresSafeArea()
                    

            }
        }
    }

    private var profileHeader: some View {
        ZStack {
            Image(uiImage: UIImage(named: selectedAvatar) ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .onTapGesture {
                    withAnimation (.bouncy(duration: 0)){
                        isExpanded = true
                    }
                }

            RoundedRectangle(cornerRadius: 5)
                .fill(Color.AvatarPopColor)
                .frame(width: 100, height: 20)
                .overlay(
                    Text(perfilName)
                        .font(.custom("RifficFree-Bold", size: 15))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                )
                .onTapGesture {
                    withAnimation (.bouncy(duration: 0)){
                        isExpanded = true
                    }
                }
                .padding(.top, 70)
        }
        .position(CGPoint(x: appData.UISW * 0.06, y: appData.UISH * 0.1))
    }
    
    private var expandedProfileView: some View {
        ZStack {
            Image(uiImage: UIImage(named: selectedAvatar) ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .position(CGPoint(x: appData.UISW * 0.09, y: appData.UISH * 0.1))
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.AvatarPopColor)
                .frame(width: 170, height: 200)
                .overlay(
                    VStack {
                        Text(perfilName)
                            .font(.custom("RifficFree-Bold", size: 20))
                            .foregroundColor(.white)

                        Text("Intentos: \(perfil.ejerciciosCompletados)")
                            .font(.custom("RifficFree-Bold", size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.secondary.cornerRadius(10.0))

                        Button("Salir", systemImage: "arrow.turn.down.left") {
                            withAnimation {
                                isExpanded = false
                                showSelectTableView = false
                            }
                        }.font(.custom("RifficFree-Bold", size: 20))
                            .foregroundColor(.red)
                            .frame(width: 130, height: 50, alignment: .center)                        .background(Color.white)
                            .cornerRadius(10)
                        
                    }
                        .padding(.horizontal)
                )
                .position(CGPoint(x: appData.UISW * 0.09, y: appData.UISH * 0.255))
        }
    }

    func currentCards() -> [Card] {
        let totalSections = totalSections()
        let startIndex = currentIndex * 3

        if currentIndex == totalSections - 1 {
            // Show 10 and 11 together
            return [cards[9], cards[10]]
        } else {
            let endIndex = min(startIndex + 3, cards.count)
            return Array(cards[startIndex..<endIndex])
        }
    }

    func nextSection() {
        if currentIndex < totalSections() - 1 {
            currentIndex += 1
        }
    }

    func previousSection() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }

    func totalSections() -> Int {
        // Correct the section calculation to ensure 10 and 11 are shown together at the end
        return (cards.count - 2) / 3 + 1
    }

    func selectCard(_ id: Int) {
        selectedCard = id
    }

    func incrementExercises() {
        DataManager.shared.incrementEjerciciosCompletados(for: perfil)
    }
}


#Preview {
    PerfilesView(onHome: {})
        .environmentObject(AppData())
}

