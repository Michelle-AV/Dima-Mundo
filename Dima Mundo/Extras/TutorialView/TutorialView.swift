import SwiftUI

enum TutorialViewType {
    case crearPerfil(String)
    case ejercicios
    case elegirTabla
    case elegirPerfil(Bool)
    case reto
}

struct TutorialView: View {

    @EnvironmentObject var appData: AppData
    @EnvironmentObject var perfilesViewModel: PerfilesViewModel
    @StateObject private var riveModel = RiveModel()
    @State var frame: CGRect = CGRect(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.25, width: 450, height: 90)
    
    var viewType: TutorialViewType
    
    @State var button: Bool = false
    
    let imageNames = ["jackFace", "melodyFace", "mollyFace", "moninFace", "pabloFace"]
    
    let colors: [String: Color] = [
        "melodyFace": .melodyColor,
        "mollyFace": .mollyColor,
        "moninFace": .moninColor,
        "jackFace": .jackColor,
        "pabloFace": .pabloColor
    ]
    
    let handImages: [String: String] = [
        "jackFace": "jackHand",
        "melodyFace": "melodyHand",
        "mollyFace": "mollyHand",
        "moninFace": "moninHand",
        "pabloFace": "pabloHand"
    ]

    
    var randomImageName: String {
        return imageNames.randomElement() ?? "melodyFace"
    }
    
    @State var dialog: String = "Coloca tu nombre en el recuadro blanco de arriba"
    @State private var selectedImage: String = ""
    @State private var selectedColor: Color = .black
    @State var isEven: Bool = false
    
    /// Variables para la mano
    @State var tiltOffsetY: CGFloat = 0
    @State var tiltOffsetX: CGFloat = 0
    @State var degrees: CGFloat = 0
    @State var positionX: CGFloat = 0
    @State var positionY: CGFloat = 0
    @State var opacity: CGFloat = 1
    
    var body: some View {
        
        ZStack {

            switch viewType {
            case .crearPerfil (let userName):
                ZStack {
                    Color.black
                        .opacity(0.77)
                        .ignoresSafeArea()
                        .mask(
                            ZStack {
                                Rectangle()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .frame(width: frame.width, height: frame.height)
                                            .position(x: frame.minX, y: frame.minY)
                                            .blendMode(.destinationOut)
                                    )
                                if appData.FlagTuto == 2 {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: appData.UISW * 0.3, height: appData.UISH * 0.14)
                                        .position(x: appData.UISW * 0.2, y: appData.UISH * 0.85)
                                        .blendMode(.destinationOut)
                                    
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: appData.UISW * 0.3, height: appData.UISH * 0.14)
                                        .position(x: appData.UISW * 0.8, y: appData.UISH * 0.85)
                                        .blendMode(.destinationOut)
                                }
                            }
                        )
                        .compositingGroup()
                        .allowsHitTesting(false)

                    
                    Rectangle()
                        .foregroundColor(.white.opacity(0.0000000000000001))
                        .frame(width: appData.UISW, height: appData.UISH * 0.3)
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.02)
                    
                    if appData.FlagTuto == 0 || appData.FlagTuto == 1 {
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.9, y: (appData.FlagTuto == 1) ? appData.UISH * 0.3 : appData.UISH * 0.455)
                    }
                    
                    if appData.FlagTuto == 0{
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW, height: appData.UISH * 0.3)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.85)
                            .onAppear {
                                degrees = 0
                                positionX = appData.UISW * 0.24
                                positionY = appData.UISH * 0.4
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = 20
                                    tiltOffsetY = 20
                                }
                                if appData.sound {
                                    SoundManager.instance.playDialogES(sound: .AC1, loop: false)
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(110))
                                .offset(x: 239, y: 40)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.435, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 400)
                                .multilineTextAlignment(.center)
                        }
                        .position(x: appData.UISW * 0.61, y: appData.UISH * 0.43)
                        
                        Button{
                            withAnimation (.spring(duration: 0.2)){
                                appData.FlagTuto = 2
                                SoundManager.instance.stopDialog()
                            }
                        } label: {
                            Text("Continuar")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                        }.disabled(!button)
                            .background(selectedColor)
                            .cornerRadius(8)
                            .position(x: appData.UISW * 0.74, y: appData.UISH * 0.52)
                        
                    } else if appData.FlagTuto == 2 {
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW, height: appData.UISH * 0.33)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.15)
                            .onAppear {
                                withAnimation(.smooth(duration: 0.3)) {
                                    degrees = 50
                                    positionX = appData.UISW * 0.24
                                    positionY = appData.UISH * 0.6
                                    tiltOffsetY = 20
                                    tiltOffsetX = 0
                                }
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = 20
                                    tiltOffsetY = 20
                                }
                            }
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.15, height: appData.UISH * 0.18)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.87)
                        
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.1, y: appData.UISH * 0.43)
                            .onAppear{
                                dialog = "Escoge a tu dima amigo favorito para comenzar"
                                withAnimation (.smooth(duration: 0.2)){
                                    self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.55, width: 300, height: 350)
                                }
                                if appData.sound {
                                    SoundManager.instance.playDialogES(sound: .AC2, loop: false)
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(200))
                                .offset(x: -130, y: 75)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.3, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 350)
                                .multilineTextAlignment(.center)
                        }
                        .position(x: appData.UISW * 0.23, y: appData.UISH * 0.23)
                        
                        Button{
                            withAnimation (.spring(duration: 0.2)){
                                appData.FlagTuto = 3
                                SoundManager.instance.stopDialog()
                            }
                        } label: {
                            Text("Continuar")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                        }.background(selectedColor)
                            .cornerRadius(8)
                            .position(x: appData.UISW * 0.29, y: appData.UISH * 0.32)
                        
                    } else if appData.FlagTuto == 3 {
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW, height: appData.UISH * 0.33)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.15)
                            .onAppear {
                                withAnimation(.smooth(duration: 0.3)) {
                                    degrees = 100
                                    positionX = appData.UISW * 0.36
                                    positionY = appData.UISH * 0.66
                                    tiltOffsetY = 0
                                    tiltOffsetX = 10
                                }
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = 20
                                    tiltOffsetY = -20
                                }
                            }
                        
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.3, height: appData.UISH * 0.14)
                            .position(x: appData.UISW * 0.2, y: appData.UISH * 0.85)
                        
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.3, height: appData.UISH * 0.14)
                            .position(x: appData.UISW * 0.8, y: appData.UISH * 0.85)
                        
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.7, y: appData.UISH * 0.6)
                            .onAppear{
                                dialog = "Una vez que escojas, presiona el botón de agregar"
                                withAnimation (.smooth(duration: 0.2)){
                                    self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.87, width: 130, height: 170)
                                }
                                if appData.sound {
                                    SoundManager.instance.playDialogES(sound: .AC3, loop: false)
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(200))
                                .offset(x: -130, y: 75)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.33, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 340)
                                .multilineTextAlignment(.leading)
                                .offset(y: -10)
                        }
                        .position(x: appData.UISW * 0.82, y: appData.UISH * 0.4)
                        
                    }
                    
                    Button{
                        withAnimation(.easeInOut(duration: 0.1)) {
                            appData.sound.toggle()
                        }
                    } label: {
                        Image(appData.sound ? "sound" : "mute")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                           
                    }.position(x: appData.UISW * 0.94, y: appData.UISH * 0.09)
                }.onAppear{
                    if userName == "" || userName == nil {
                        button = false
                    } else {
                        button = true
                    }
                    self.frame = CGRect(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.25, width: 450, height: 90)
                    appData.FlagTuto = 0
                }
                .onChange(of: userName){ newValue in
                    if newValue == "" || newValue == nil {
                        button = false
                    } else {
                        button = true
                    }
                }

            case .ejercicios:
                ZStack {
                    Color.black
                        .opacity(0.77)
                        .ignoresSafeArea()
                        .mask(
                            ZStack {
                                Rectangle()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .frame(width: frame.width, height: frame.height)
                                            .position(x: frame.minX, y: frame.minY)
                                            .blendMode(.destinationOut)
                                    )
                                if appData.FlagTuto == 16 {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: appData.UISW * 0.78, height: appData.UISH * 0.14)
                                        .position(x: appData.UISW * 0.415, y: appData.UISH * 0.9)
                                        .blendMode(.destinationOut)
                                } else if appData.FlagTuto == 9 {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 160, height: 130)
                                        .position(x: appData.UISW * 0.66, y: appData.UISH * 0.34)
                                        .blendMode(.destinationOut)
                                }
                            }
                        )
                        .compositingGroup()
                        .allowsHitTesting(false)

                    
                    Rectangle()
                        .foregroundColor(.white.opacity(0.0000000000000001))
                        .frame(width: appData.UISW, height: appData.UISH * 0.3)
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.02)
                    

                    
                    if appData.FlagTuto == 16{
                        
                        Rectangle()                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.2, height: appData.UISH * 0.2)
                            .position(x: appData.UISW * 0.904, y: appData.UISH * 0.9)
                            .onAppear {
                                withAnimation (.smooth(duration: 0.2)){
                                    degrees = 143
                                    positionX = appData.UISW * 0.2
                                    positionY = appData.UISH * 0.67
                                    tiltOffsetX = 0
                                    tiltOffsetY = 0
                                }
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = 0
                                    tiltOffsetY = 20
                                }
                            }
                        
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.86, y: appData.UISH * 0.6)
                            .onAppear{
                                dialog = "Presiona los números y se colocarán en el pizarrón."
                                appData.FlagTuto = 16
                                self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.35, width: appData.UISW * 0.5, height: appData.UISH * 0.2)
                                if appData.sound {
                                    SoundManager.instance.playDialogES(sound: .AE1, loop: false)
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(110))
                                .offset(x: 188, y: 10)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.34, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 320)
                                .multilineTextAlignment(.center)
                        }
                        .position(x: appData.UISW * 0.61, y: appData.UISH * 0.6)
                        
                        Button{
                            withAnimation (.spring(duration: 0.2)){
                                appData.FlagTuto = 9
                                SoundManager.instance.stopDialog()
                            }
                        } label: {
                            Text("Continuar")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                        }
                            .background(selectedColor)
                            .cornerRadius(8)
                            .position(x: appData.UISW * 0.7, y: appData.UISH * 0.69)
                        
                    } else if appData.FlagTuto == 9 {
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.78, height: appData.UISH * 0.14)
                            .position(x: appData.UISW * 0.415, y: appData.UISH * 0.9)
                            .onAppear {
                                withAnimation (.smooth(duration: 0.2)){
                                    degrees = 50
                                    positionX = appData.UISW * 0.7
                                    positionY = appData.UISH * 0.9
                                    tiltOffsetX = 0
                                    tiltOffsetY = 0
                                }
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = 20
                                    tiltOffsetY = 0
                                }
                            }
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: 90, height: 90)
                            .position(x: appData.UISW * 0.93, y: appData.UISH * 0.9)
                        
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.86, y: appData.UISH * 0.6)
                            .onAppear{
                                dialog = "Si quieres cambiar la respuesta, borra con el botón a la derecha del 0."
                                self.frame = CGRect(x: appData.UISW * 0.842, y: appData.UISH * 0.9, width: 90, height: 90)
                                if appData.sound {
                                    SoundManager.instance.playDialogES(sound: .AE2, loop: false)
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(110))
                                .offset(x: 248, y: 10)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.45, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 480)
                                .multilineTextAlignment(.center)
                        }
                        .position(x: appData.UISW * 0.55, y: appData.UISH * 0.6)
                        
                        Button{
                            withAnimation (.spring(duration: 0.2)){
                                appData.FlagTuto = 10
                                SoundManager.instance.stopDialog()
                            }
                        } label: {
                            Text("Continuar")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                        }
                            .background(selectedColor)
                            .cornerRadius(8)
                            .position(x: appData.UISW * 0.67, y: appData.UISH * 0.69)
                        
                    } else if appData.FlagTuto == 10 {
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.95, height: appData.UISH * 0.14)
                            .position(x: appData.UISW * 0.415, y: appData.UISH * 0.9)
                            .onAppear {
                                withAnimation (.smooth(duration: 0.2)){
                                    degrees = 50
                                    positionX = appData.UISW * 0.8
                                    positionY = appData.UISH * 0.9
                                    tiltOffsetX = 0
                                    tiltOffsetY = 0
                                }
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = 20
                                    tiltOffsetY = 0
                                }
                            }
                        
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.86, y: appData.UISH * 0.6)
                            .onAppear{
                                dialog = "Cuando tengas la respuesta, presiona la palomita al final del teclado."
                                self.frame = CGRect(x: appData.UISW * 0.932, y: appData.UISH * 0.9, width: 90, height: 90)
                                if appData.sound {
                                    SoundManager.instance.playDialogES(sound: .AE3, loop: false)
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(110))
                                .offset(x: 274, y: 10)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.5, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 480)
                                .multilineTextAlignment(.center)
                        }
                        .position(x: appData.UISW * 0.53, y: appData.UISH * 0.6)
                        
                        Button{
                            withAnimation (.spring(duration: 0.2)){
                                appData.FlagTuto = 11
                                SoundManager.instance.stopDialog()
                            }
                        } label: {
                            Text("Continuar")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                        }
                            .background(selectedColor)
                            .cornerRadius(8)
                            .position(x: appData.UISW * 0.69, y: appData.UISH * 0.69)
                    } else if appData.FlagTuto == 11 {
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW, height: appData.UISH * 0.14)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.9)
                            .onAppear {
                                withAnimation (.smooth(duration: 0.2)){
                                    degrees = 0
                                    positionX = appData.UISW * 0.72
                                    positionY = appData.UISH * 0.36
                                    tiltOffsetX = 0
                                    tiltOffsetY = 10
                                }
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = 10
                                    tiltOffsetY = 30
                                }
                            }
                        
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.86, y: appData.UISH * 0.6)
                            .onAppear{
                                dialog = "Repite esos pasos para los 5 ejercicios. ¡Te deseo mucho éxito!"
                                self.frame = CGRect(x: appData.UISW * 0.8, y: appData.UISH * 0.17, width: 140, height: 120)
                                if appData.sound {
                                    SoundManager.instance.playDialogES(sound: .AE4, loop: false)
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(110))
                                .offset(x: 274, y: 10)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.5, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 480)
                                .multilineTextAlignment(.center)
                        }
                        .position(x: appData.UISW * 0.53, y: appData.UISH * 0.6)
                        
                        Button{
                            withAnimation (.spring(duration: 0.2)){
                                appData.isTuto = false
                                SoundManager.instance.stopDialog()
                            }
                        } label: {
                            Text("Continuar")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                        }
                            .background(selectedColor)
                            .cornerRadius(8)
                            .position(x: appData.UISW * 0.69, y: appData.UISH * 0.69)
                    }
                    
                    Button{
                        withAnimation(.easeInOut(duration: 0.1)) {
                            appData.sound.toggle()
                        }
                    } label: {
                        Image(appData.sound ? "sound" : "mute")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                           
                    }.position(x: appData.UISW * 0.94, y: appData.UISH * 0.09)
                                    
                }.onAppear{
                    appData.FlagTuto = 16
                }
                
            case .elegirTabla:
                ZStack {
                    Color.black
                        .opacity(0.77)
                        .ignoresSafeArea()
                        .mask(
                            ZStack {
                                Rectangle()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .frame(width: frame.width, height: frame.height)
                                            .position(x: frame.minX, y: frame.minY)
                                            .blendMode(.destinationOut)
                                    )
                                if appData.FlagTuto == 6 {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: 100, height: 100)
                                        .position(x: appData.UISW * 0.9, y: appData.UISH * 0.5)
                                        .blendMode(.destinationOut)
                                }
                            }
                        )
                        .compositingGroup()
                        .allowsHitTesting(false)

                    
                    Rectangle()
                        .foregroundColor(.white.opacity(0.0000000000000001))
                        .frame(width: appData.FlagTuto == 7 || appData.FlagTuto == 8 ? appData.UISW * 0.8: appData.UISW, height: appData.UISH * 0.3)
                        .position(x: appData.FlagTuto == 7 || appData.FlagTuto == 8 ? appData.UISW * 0.6 : appData.UISW * 0.5, y: appData.UISH * 0.02)
                    

                    
                    if appData.FlagTuto == 17{
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.1, height: appData.UISH * 0.1)
                            .position(x: appData.UISW * 0.815, y: appData.UISH * 0.64)
                            .onAppear {
                                withAnimation (.smooth(duration: 0.2)){
                                    degrees = -40
                                    positionX = appData.UISW * 0.18
                                    positionY = appData.UISH * 0.82
                                    tiltOffsetX = 0
                                    tiltOffsetY = 0
                                }
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = 0
                                    tiltOffsetY = 20
                                }
                            }
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.1, height: appData.UISH * 0.1)
                            .position(x: appData.UISW * 0.57, y: appData.UISH * 0.64)
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.1, height: appData.UISH * 0.1)
                            .position(x: appData.UISW * 0.33, y: appData.UISH * 0.64)
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.1, height: appData.UISH)
                            .position(x: appData.UISW * 0.91, y: appData.UISH * 0.5)
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.1, height: appData.UISH)
                            .position(x: appData.UISW * 0.09, y: appData.UISH * 0.5)
                        
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.91, y: appData.UISH * 0.82)
                            .onAppear{
                                dialog = "Elige una tabla para practicar seleccionando uno de los recuadros que aparecen en la pantalla."
                                appData.FlagTuto = 17
                                self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.45, width: appData.UISW * 0.73, height: appData.UISH * 0.5)
                                if appData.sound {
                                    SoundManager.instance.playDialogES(sound: .AT1, loop: false)
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(110))
                                .offset(x: 310, y: 40)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.57, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 580)
                                .multilineTextAlignment(.center)
                        }
                        .position(x: appData.UISW * 0.548, y: appData.UISH * 0.82)
                        
                        Button{
                            withAnimation (.spring(duration: 0.2)){
                                appData.FlagTuto = 6
                                SoundManager.instance.stopDialog()
                            }
                        } label: {
                            Text("Continuar")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                        }
                            .background(selectedColor)
                            .cornerRadius(8)
                            .position(x: appData.UISW * 0.74, y: appData.UISH * 0.9)
                        
                    } else if appData.FlagTuto == 6 {
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.73, height: appData.UISH * 0.5)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.45)
                            .onAppear {
                                withAnimation (.smooth(duration: 0.2)){
                                    degrees = 100
                                    positionX = appData.UISW * 0.78
                                    positionY = appData.UISH * 0.3
                                    tiltOffsetX = 0
                                    tiltOffsetY = 0
                                }
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = -10
                                    tiltOffsetY = 20
                                }
                            }
                        
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.74, y: appData.UISH * 0.7)
                            .onAppear{
                                dialog = "Usa los botones de los laterales para ver mas tablas."
                                withAnimation (.smooth(duration: 0.2)){
                                    self.frame = CGRect(x: appData.UISW * 0.1, y: appData.UISH * 0.5, width: 100, height: 100)
                                }
                                if appData.sound {
                                    SoundManager.instance.playDialogES(sound: .AT2, loop: false)
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(110))
                                .offset(x: 220, y: 40)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.4, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 380)
                                .multilineTextAlignment(.center)
                        }
                        .position(x: appData.UISW * 0.46, y: appData.UISH * 0.7)
                        
                        Button{
                            withAnimation (.spring(duration: 0.2)){
                                appData.FlagTuto = 7
                                SoundManager.instance.stopDialog()
                            }
                        } label: {
                            Text("Continuar")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                        }.background(selectedColor)
                            .cornerRadius(8)
                            .position(x: appData.UISW * 0.57, y: appData.UISH * 0.78)
                        
                    } else if appData.FlagTuto == 7 {
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.73, height: appData.UISH * 0.5)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.45)
                            .onAppear {
                                withAnimation (.smooth(duration: 0.2)){
                                    degrees = -60
                                    positionX = appData.UISW * 0.12
                                    positionY = appData.UISH * 0.3
                                    tiltOffsetX = 0
                                    tiltOffsetY = 0
                                }
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = -10
                                    tiltOffsetY = 20
                                }
                            }
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: 100, height: 100)
                            .position(x: appData.UISW * 0.9, y: appData.UISH * 0.5)
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: 100, height: 100)
                            .position(x: appData.UISW * 0.1, y: appData.UISH * 0.5)
                        
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.62, y: appData.UISH * 0.28)
                            .onAppear{
                                dialog = "Selecciona tu perfil para poder cambiarlo."
                                withAnimation (.smooth(duration: 0.2)){
                                    self.frame = CGRect(x: appData.UISW * 0.06, y: appData.UISH * 0.1, width: 100, height: 100)
                                }
                                if appData.sound {
                                    SoundManager.instance.playDialogES(sound: .AT3, loop: false)
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(200))
                                .offset(x: 185, y: 0)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.34, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 500)
                                .multilineTextAlignment(.center)
                                .offset(y: -10)
                        }
                        .position(x: appData.UISW * 0.37, y: appData.UISH * 0.28)
                        
                        Button{
                            withAnimation (.spring(duration: 0.2)){
                                appData.isTuto = false
                                SoundManager.instance.stopDialog()
                            }
                        } label: {
                            Text("¡Entendido!")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                        }
                            .background(selectedColor)
                            .cornerRadius(8)
                            .position(x: appData.UISW * 0.44, y: appData.UISH * 0.36)
                    } else if appData.FlagTuto == 8 {
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.73, height: appData.UISH * 0.5)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.45)
                            .onAppear {
                                withAnimation (.smooth(duration: 0.2)){
                                    degrees = -60
                                    positionX = appData.UISW * 0.12
                                    positionY = appData.UISH * 0.5
                                    tiltOffsetX = 0
                                    tiltOffsetY = 0
                                }
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = -10
                                    tiltOffsetY = 20
                                }
                            }
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: 100, height: 100)
                            .position(x: appData.UISW * 0.9, y: appData.UISH * 0.5)
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: 100, height: 100)
                            .position(x: appData.UISW * 0.1, y: appData.UISH * 0.5)
                        
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.62, y: appData.UISH * 0.28)
                            .onAppear{
                                dialog = "Selecciona tu perfil para poder cambiarlo."
                                withAnimation (.smooth(duration: 0.2)){
                                    self.frame = CGRect(x: appData.UISW * 0.09, y: appData.UISH * 0.23, width: 170, height: 300)
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(200))
                                .offset(x: 185, y: 0)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.34, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 500)
                                .multilineTextAlignment(.center)
                                .offset(y: -10)
                        }
                        .position(x: appData.UISW * 0.37, y: appData.UISH * 0.28)
                        
                        Button{
                            withAnimation (.spring(duration: 0.2)){
                                appData.isTuto = false
                                SoundManager.instance.stopDialog()
                            }
                        } label: {
                            Text("¡Entendido!")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                        }
                            .background(selectedColor)
                            .cornerRadius(8)
                            .position(x: appData.UISW * 0.44, y: appData.UISH * 0.36)
                    }
                    
                    Button{
                        withAnimation(.easeInOut(duration: 0.1)) {
                            appData.sound.toggle()
                        }
                    } label: {
                        Image(appData.sound ? "sound" : "mute")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                           
                    }.position(x: appData.UISW * 0.94, y: appData.UISH * 0.09)
                                    
                }.onAppear{
                    appData.FlagTuto = 17
                }
            case .elegirPerfil (let selectedPerfil):
                ZStack {
                    Color.black
                        .opacity(0.77)
                        .ignoresSafeArea()
                        .mask(
                            ZStack {
                                Rectangle()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .frame(width: frame.width, height: frame.height)
                                            .position(x: frame.minX, y: frame.minY)
                                            .blendMode(.destinationOut)
                                    )
                                if appData.FlagTuto == 2 {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: appData.UISW * 0.3, height: appData.UISH * 0.14)
                                        .position(x: appData.UISW * 0.2, y: appData.UISH * 0.85)
                                        .blendMode(.destinationOut)
                                    
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: appData.UISW * 0.3, height: appData.UISH * 0.14)
                                        .position(x: appData.UISW * 0.8, y: appData.UISH * 0.85)
                                        .blendMode(.destinationOut)
                                }
                            }
                        )
                        .compositingGroup()
                        .allowsHitTesting(false)

                    
                    Rectangle()
                        .foregroundColor(.white.opacity(0.0000000000000001))
                        .frame(width: appData.UISW, height: appData.UISH * 0.3)
                        .position(x: appData.UISW * 0.5, y: appData.UISH * 0.02)
                    

                    
                    if appData.FlagTuto == 18{
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW, height: appData.UISH * 0.3)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.85)
                            .onAppear {
                                degrees = 50
                                if selectedPerfil && isEven {
                                    positionX = appData.UISW * 0.23
                                    positionY = appData.UISH * 0.5
                                } else if selectedPerfil {
                                    positionX = appData.UISW * 0.25
                                    positionY = appData.UISH * 0.5
                                } else if isEven {
                                    positionX = appData.UISW * 0.3
                                    positionY = appData.UISH * 0.5
                                } else {
                                    positionX = appData.UISW * 0.3
                                    positionY = appData.UISH * 0.5
                                }
                                tiltOffsetX = 0
                                tiltOffsetY = 20
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = 20
                                    tiltOffsetY = 20
                                }
                            }
                        
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.91, y: appData.UISH * 0.8)
                            .onAppear{
                                dialog = "Para empezar la aventura, selecciona tu perfil."
                                if isEven {
                                    if selectedPerfil {
                                        self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.48, width: 320, height: 210)
                                    } else {
                                        self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.48, width: 320, height: 210)
                                    }
                                } else {
                                    if selectedPerfil {
                                        self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.48, width: 300, height: 300)
                                    } else {
                                        self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.48, width: 150, height: 210)
                                    }
                                }
                                if appData.sound {
                                    SoundManager.instance.playDialogES(sound: .AP1, loop: false)
                                }
                            }
                            .onChange(of: selectedPerfil) { newValue in
                                withAnimation (.smooth(duration: 0.3)){
                                    if isEven {
                                        if newValue {
                                            self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.48, width: 320, height: 300)
                                        } else {
                                            self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.48, width: 320, height: 210)
                                        }
                                    } else {
                                        if newValue {
                                            self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.48, width: 300, height: 300)
                                            positionX = appData.UISW * 0.25
                                        } else {
                                            self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.48, width: 150, height: 210)
                                            positionX = appData.UISW * 0.3
                                        }
                                    }
                                    if newValue && isEven {
                                        positionX = appData.UISW * 0.23
                                        positionY = appData.UISH * 0.5
                                    } else if newValue {
                                        positionX = appData.UISW * 0.25
                                        positionY = appData.UISH * 0.5
                                    } else if isEven {
                                        positionX = appData.UISW * 0.3
                                        positionY = appData.UISH * 0.5
                                    } else {
                                        positionX = appData.UISW * 0.3
                                        positionY = appData.UISH * 0.5
                                    }
                                    tiltOffsetX = 0
                                    tiltOffsetY = 20
                                    withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                        tiltOffsetX = 20
                                        tiltOffsetY = 20
                                    }
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(110))
                                .offset(x: 239, y: 40)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.435, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 400)
                                .multilineTextAlignment(.center)
                        }
                        .position(x: appData.UISW * 0.61, y: appData.UISH * 0.8)
                        
                        Button{
                            withAnimation (.spring(duration: 0.2)){
                                appData.FlagTuto = 5
                                SoundManager.instance.stopDialog()
                            }
                        } label: {
                            Text("Continuar")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                        }.disabled(!selectedPerfil)
                            .background(selectedColor)
                            .cornerRadius(8)
                            .position(x: appData.UISW * 0.74, y: appData.UISH * 0.88)
                            .opacity(!selectedPerfil ? 0 : 1)
                        
                    } else if appData.FlagTuto == 4 {
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW, height: appData.UISH * 0.33)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.15)
                            .onAppear {
                                withAnimation (.smooth(duration: 0.2)){
                                    degrees = 100
                                    positionX = appData.UISW * 0.34
                                    positionY = appData.UISH * 0.65
                                    tiltOffsetX = 10
                                    tiltOffsetY = 0
                                }
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = 20
                                    tiltOffsetY = -20
                                }
                            }
                        
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.1, height: appData.UISH * 0.12)
                            .position(x: appData.UISW * 0.08, y: appData.UISH * 0.8)
                        
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW, height: appData.UISH * 0.25)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.5)
                        
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.91, y: appData.UISH * 0.23)
                            .onAppear{
                                dialog = "Una vez seleccionado, presiona el botón de ''Iniciar''"
                                withAnimation (.smooth(duration: 0.2)){
                                    self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.8, width: 120, height: 80)
                                }
                                if appData.sound {
                                    SoundManager.instance.playDialogES(sound: .AP2, loop: false)
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(110))
                                .offset(x: 220, y: 40)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.4, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 380)
                                .multilineTextAlignment(.center)
                        }
                        .position(x: appData.UISW * 0.62, y: appData.UISH * 0.23)
                        
                        Button{
                            withAnimation (.spring(duration: 0.2)){
                                appData.isTuto = false
                                SoundManager.instance.stopDialog()
                            }
                        } label: {
                            Text("Continuar")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                        }.disabled(appData.firstTime)
                        .background(selectedColor)
                            .cornerRadius(8)
                            .position(x: appData.UISW * 0.72, y: appData.UISH * 0.32)
                            .opacity(appData.firstTime ? 0 : 1)
                        
                    } else if appData.FlagTuto == 5 {
                        
                        Rectangle()
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW, height: appData.UISH * 0.33)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.15)
                            .onAppear {
                                withAnimation (.smooth(duration: 0.2)){
                                    degrees = -100
                                    positionX = appData.UISW * 0.2
                                    positionY = appData.UISH * 0.86
                                    tiltOffsetX = 0
                                    tiltOffsetY = 10
                                }
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                    tiltOffsetX = 20
                                    tiltOffsetY = 0
                                }
                            }
                        
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW * 0.5, height: appData.UISH * 0.12)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.8)
                        
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.white.opacity(0.0000000000000001))
                            .frame(width: appData.UISW, height: appData.UISH * 0.25)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.5)
                        
                        Image(selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                            .position(x: appData.UISW * 0.7, y: appData.UISH * 0.6)
                            .onAppear{
                                dialog = "En caso de no tener uno, da click en el botón de ''+'' para crear un perfil nuevo."
                                withAnimation (.smooth(duration: 0.2)){
                                    self.frame = CGRect(x: appData.UISW * 0.06, y: appData.UISH * 0.80, width: 80, height: 80)
                                }
                                if appData.sound {
                                    SoundManager.instance.playDialogES(sound: .AP3, loop: false)
                                }
                            }
                        
                        ZStack {
                            Image("triangulo")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(200))
                                .offset(x: 260, y: 0)
                                .frame(width: 20)
                            
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .frame(width: appData.UISW * 0.48, height: appData.UISH * 0.175)
                            
                            Text(dialog)
                                .font(.custom("RifficFree-Bold", size: 25))
                                .foregroundColor(selectedColor)
                                .frame(width: 500)
                                .multilineTextAlignment(.leading)
                                .offset(y: -10)
                        }
                        .position(x: appData.UISW * 0.37, y: appData.UISH * 0.63)
                        
                        Button{
                            withAnimation (.spring(duration: 0.2)){
                                appData.FlagTuto = 4
                                SoundManager.instance.stopDialog()
                            }
                        } label: {
                            Text("¡Entendido!")
                                .font(.custom("RifficFree-Bold", size: 20))
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                        }
                            .background(selectedColor)
                            .cornerRadius(8)
                            .position(x: appData.UISW * 0.5, y: appData.UISH * 0.72)
                    }
                    
                    Button{
                        withAnimation(.easeInOut(duration: 0.1)) {
                            appData.sound.toggle()
                        }
                    } label: {
                        Image(appData.sound ? "sound" : "mute")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                           
                    }.position(x: appData.UISW * 0.94, y: appData.UISH * 0.09)
                                    
                }.onAppear{
                    appData.FlagTuto = 18
                }
                
            case .reto:
                ZStack {
                   Color.black
                       .opacity(0.77)
                       .ignoresSafeArea()
                       .mask(
                           ZStack {
                               Rectangle()
                                   .overlay(
                                       RoundedRectangle(cornerRadius: 25)
                                           .frame(width: frame.width, height: frame.height)
                                           .position(x: frame.minX, y: frame.minY)
                                           .blendMode(.destinationOut)
                                   )
                           }
                       )
                       .compositingGroup()
                       .allowsHitTesting(false)

                   
                   Rectangle()
                       .foregroundColor(.white.opacity(0.0000000000000001))
                       .frame(width: appData.UISW, height: appData.UISH * 0.3)
                       .position(x: appData.UISW * 0.5, y: appData.UISH * 0.02)
                   

                   
                   if appData.FlagTuto == 19{
                       
                       Rectangle()
                           .foregroundColor(.white.opacity(0.0000000000000001))
                           .frame(width: appData.UISW, height: appData.UISH)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.5)
                           .onAppear {
                               opacity = 0
                           }
                       
                       Image(selectedImage)
                           .resizable()
                           .scaledToFit()
                           .frame(width: 130)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.66)
                           .onAppear{
                               dialog = "¿Estás listo para una aventura más desafiante?"
                               appData.FlagTuto = 19
                               self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.35, width: appData.UISW * 0, height: appData.UISH * 0)
                               if appData.sound {
                                   SoundManager.instance.playDialogES(sound: .AR1, loop: false)
                               }
                           }
                       
                       ZStack {
                           Image("triangulo")
                               .resizable()
                               .scaledToFit()
                               .rotationEffect(.degrees(70))
                               .offset(x: 0, y: 70)
                               .frame(width: 20)
                           
                           RoundedRectangle(cornerRadius: 25)
                               .foregroundColor(.white)
                               .frame(width: appData.UISW * 0.34, height: appData.UISH * 0.175)
                           
                           Text(dialog)
                               .font(.custom("RifficFree-Bold", size: 25))
                               .foregroundColor(selectedColor)
                               .frame(width: 320)
                               .multilineTextAlignment(.center)
                       }
                       .position(x: appData.UISW * 0.5, y: appData.UISH * 0.45)
                       
                       Button{
                           withAnimation (.spring(duration: 0.2)){
                               appData.FlagTuto = 12
                               SoundManager.instance.stopDialog()
                           }
                       } label: {
                           Text("Continuar")
                               .font(.custom("RifficFree-Bold", size: 20))
                               .padding(.horizontal)
                               .padding(.vertical, 10)
                               .foregroundColor(.white)
                       }
                           .background(selectedColor)
                           .cornerRadius(8)
                           .position(x: appData.UISW * 0.59, y: appData.UISH * 0.54)
                       
                   } else if appData.FlagTuto == 12 {
                       
                       Rectangle()                            .foregroundColor(.white.opacity(0.0000000000000001))
                           .frame(width: appData.UISW, height: appData.UISH)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.5)
                           .onAppear {
                               opacity = 0
                           }
                       
                       Image(selectedImage)
                           .resizable()
                           .scaledToFit()
                           .frame(width: 130)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.66)
                           .onAppear{
                               dialog = "¡Bienvenido al reto de las tablas!"
                               self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.35, width: appData.UISW * 0, height: appData.UISH * 0)
                               if appData.sound {
                                   SoundManager.instance.playDialogES(sound: .AR2, loop: false)
                               }
                           }
                       
                       ZStack {
                           Image("triangulo")
                               .resizable()
                               .scaledToFit()
                               .rotationEffect(.degrees(70))
                               .offset(x: 0, y: 70)
                               .frame(width: 20)
                           
                           RoundedRectangle(cornerRadius: 25)
                               .foregroundColor(.white)
                               .frame(width: appData.UISW * 0.4, height: appData.UISH * 0.175)
                           
                           Text(dialog)
                               .font(.custom("RifficFree-Bold", size: 25))
                               .foregroundColor(selectedColor)
                               .frame(width: 420)
                               .multilineTextAlignment(.center)
                       }
                       .position(x: appData.UISW * 0.5, y: appData.UISH * 0.45)
                       
                       Button{
                           withAnimation (.spring(duration: 0.2)){
                               appData.FlagTuto = 13
                               SoundManager.instance.stopDialog()
                           }
                       } label: {
                           Text("Continuar")
                               .font(.custom("RifficFree-Bold", size: 20))
                               .padding(.horizontal)
                               .padding(.vertical, 10)
                               .foregroundColor(.white)
                       }
                           .background(selectedColor)
                           .cornerRadius(8)
                           .position(x: appData.UISW * 0.59, y: appData.UISH * 0.54)
                       
                   } else if appData.FlagTuto == 13 {
                       
                       Rectangle()
                           .foregroundColor(.white.opacity(0.0000000000000001))
                           .frame(width: appData.UISW * 0.95, height: appData.UISH * 0.14)
                           .position(x: appData.UISW * 0.415, y: appData.UISH * 0.9)
                           .onAppear {
                               withAnimation (.smooth(duration: 0.2)){
                                   opacity = 1
                                   degrees = 0
                                   positionX = appData.UISW * 0.2
                                   positionY = appData.UISH * 0.76
                                   tiltOffsetX = 0
                                   tiltOffsetY = 0
                               }
                               withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                   tiltOffsetX = 10
                                   tiltOffsetY = 20
                               }
                           }
                       
                       Image(selectedImage)
                           .resizable()
                           .scaledToFit()
                           .frame(width: 130)
                           .position(x: appData.UISW * 0.86, y: appData.UISH * 0.8)
                           .onAppear{
                               dialog = "Así como lo hiciste con los ejercicios, tienes que completar cada multiplicación."
                               self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.38, width: appData.UISW * 0.5, height: appData.UISW * 0.38)
                               if appData.sound {
                                   SoundManager.instance.playDialogES(sound: .AR3, loop: false)
                               }
                           }
                       
                       ZStack {
                           Image("triangulo")
                               .resizable()
                               .scaledToFit()
                               .rotationEffect(.degrees(110))
                               .offset(x: 274, y: 10)
                               .frame(width: 20)
                           
                           RoundedRectangle(cornerRadius: 25)
                               .foregroundColor(.white)
                               .frame(width: appData.UISW * 0.5, height: appData.UISH * 0.175)
                           
                           Text(dialog)
                               .font(.custom("RifficFree-Bold", size: 25))
                               .foregroundColor(selectedColor)
                               .frame(width: 500)
                               .multilineTextAlignment(.center)
                       }
                       .position(x: appData.UISW * 0.53, y: appData.UISH * 0.8)
                       
                       Button{
                           withAnimation (.spring(duration: 0.2)){
                               appData.FlagTuto = 20
                               SoundManager.instance.stopDialog()
                           }
                       } label: {
                           Text("Continuar")
                               .font(.custom("RifficFree-Bold", size: 20))
                               .padding(.horizontal)
                               .padding(.vertical, 10)
                               .foregroundColor(.white)
                       }
                           .background(selectedColor)
                           .cornerRadius(8)
                           .position(x: appData.UISW * 0.69, y: appData.UISH * 0.89)
                   } else if appData.FlagTuto == 14 {
                       
                       Rectangle()
                           .foregroundColor(.white.opacity(0.0000000000000001))
                           .frame(width: appData.UISW, height: appData.UISH)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.5)
                           .onAppear {
                               withAnimation (.smooth(duration: 0.2)){
                                   degrees = 0
                                   positionX = appData.UISW * 0.72
                                   positionY = appData.UISH * 0.36
                                   tiltOffsetX = 0
                                   tiltOffsetY = 10
                               }
                               withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                   tiltOffsetX = 10
                                   tiltOffsetY = 30
                               }
                           }
                       
                       Image(selectedImage)
                           .resizable()
                           .scaledToFit()
                           .frame(width: 130)
                           .position(x: appData.UISW * 0.86, y: appData.UISH * 0.6)
                           .onAppear{
                               dialog = "Pero para hacerlo más interesante... tienes que pasar 3 rondas, cada una contará con 3 ejercicios."
                               self.frame = CGRect(x: appData.UISW * 0.8, y: appData.UISH * 0.17, width: 120, height: 120)
                               if appData.sound {
                                   SoundManager.instance.playDialogES(sound: .AR4, loop: false)
                               }
                           }
                       
                       ZStack {
                           Image("triangulo")
                               .resizable()
                               .scaledToFit()
                               .rotationEffect(.degrees(110))
                               .offset(x: 274, y: 10)
                               .frame(width: 20)
                           
                           RoundedRectangle(cornerRadius: 25)
                               .foregroundColor(.white)
                               .frame(width: appData.UISW * 0.5, height: appData.UISH * 0.175)
                           
                           Text(dialog)
                               .font(.custom("RifficFree-Bold", size: 25))
                               .foregroundColor(selectedColor)
                               .frame(width: 480)
                               .multilineTextAlignment(.center)
                       }
                       .position(x: appData.UISW * 0.53, y: appData.UISH * 0.6)
                       
                       Button{
                           withAnimation (.spring(duration: 0.2)){
                               appData.FlagTuto = 15
                               SoundManager.instance.stopDialog()
                           }
                       } label: {
                           Text("Continuar")
                               .font(.custom("RifficFree-Bold", size: 20))
                               .padding(.horizontal)
                               .padding(.vertical, 10)
                               .foregroundColor(.white)
                       }
                           .background(selectedColor)
                           .cornerRadius(8)
                           .position(x: appData.UISW * 0.69, y: appData.UISH * 0.69)
                   } else if appData.FlagTuto == 15 {
                       
                       Rectangle()
                           .foregroundColor(.white.opacity(0.0000000000000001))
                           .frame(width: appData.UISW, height: appData.UISH)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.5)
                           .onAppear {
                               withAnimation (.smooth(duration: 0.2)){
                                   opacity = 0
                               }
                           }
                       
                       Image(selectedImage)
                           .resizable()
                           .scaledToFit()
                           .frame(width: 130)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.62)
                           .onAppear{
                               dialog = "¡Vamos, sé que lo harás muy bien! ¡Ánimo y mucha suerte!"
                               self.frame = CGRect(x: appData.UISW * 0.8, y: appData.UISH * 0.17, width: 0, height: 0)
                               if appData.sound {
                                   SoundManager.instance.playDialogES(sound: .AR5, loop: false)
                               }                            }
                       
                       ZStack {
                           Image("triangulo")
                               .resizable()
                               .scaledToFit()
                               .rotationEffect(.degrees(70))
                               .offset(x: 0, y: 73)
                               .frame(width: 20)
                           
                           RoundedRectangle(cornerRadius: 25)
                               .foregroundColor(.white)
                               .frame(width: appData.UISW * 0.42, height: appData.UISH * 0.175)
                           
                           Text(dialog)
                               .font(.custom("RifficFree-Bold", size: 25))
                               .foregroundColor(selectedColor)
                               .frame(width: 480)
                               .multilineTextAlignment(.center)
                       }
                       .position(x: appData.UISW * 0.53, y: appData.UISH * 0.4)
                       
                       Button{
                           withAnimation (.spring(duration: 0.2)){
                               appData.isTuto = false
                               opacity = 1
                               SoundManager.instance.stopDialog()
                           }
                       } label: {
                           Text("Continuar")
                               .font(.custom("RifficFree-Bold", size: 20))
                               .padding(.horizontal)
                               .padding(.vertical, 10)
                               .foregroundColor(.white)
                       }
                           .background(selectedColor)
                           .cornerRadius(8)
                           .position(x: appData.UISW * 0.66, y: appData.UISH * 0.49)
                   } else if appData.FlagTuto == 20 {
                       
                       Rectangle()
                           .foregroundColor(.white.opacity(0.0000000000000001))
                           .frame(width: appData.UISW, height: appData.UISH)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.5)
                           .onAppear {
                               withAnimation (.smooth(duration: 0.2)){
                                   opacity = 0
                               }
                           }
                       
                       Image(selectedImage)
                           .resizable()
                           .scaledToFit()
                           .frame(width: 130)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.62)
                           .onAppear{
                               dialog = "Un pequeño truco, para resolver los ejercicios…"
                               self.frame = CGRect(x: appData.UISW * 0.8, y: appData.UISH * 0.17, width: 0, height: 0)
                               if appData.sound {
                                   SoundManager.instance.stopDialog()
                                   //                                    SoundManager.instance.playDialogES(sound: .AR5, loop: false)
                               }
                           }
                       
                       ZStack {
                           Image("triangulo")
                               .resizable()
                               .scaledToFit()
                               .rotationEffect(.degrees(70))
                               .offset(x: 0, y: 73)
                               .frame(width: 20)
                           
                           RoundedRectangle(cornerRadius: 25)
                               .foregroundColor(.white)
                               .frame(width: appData.UISW * 0.42, height: appData.UISH * 0.175)
                           
                           Text(dialog)
                               .font(.custom("RifficFree-Bold", size: 25))
                               .foregroundColor(selectedColor)
                               .frame(width: 480)
                               .multilineTextAlignment(.center)
                       }
                       .position(x: appData.UISW * 0.53, y: appData.UISH * 0.4)
                       
                       Button{
                           withAnimation (.spring(duration: 0.2)){
                               appData.FlagTuto = 21
            //                                appData.isTuto = false
            //                                opacity = 1
            //                                SoundManager.instance.stopDialog()
                           }
                       } label: {
                           Text("Continuar")
                               .font(.custom("RifficFree-Bold", size: 20))
                               .padding(.horizontal)
                               .padding(.vertical, 10)
                               .foregroundColor(.white)
                       }
                           .background(selectedColor)
                           .cornerRadius(8)
                           .position(x: appData.UISW * 0.66, y: appData.UISH * 0.49)
                   } else if appData.FlagTuto == 21 {
                       
                       Rectangle()
                           .foregroundColor(.white.opacity(0.0000000000000001))
                           .frame(width: appData.UISW * 1, height: appData.UISH * 0.14)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.9)
                           .onAppear {
                               withAnimation (.smooth(duration: 0.2)){
                                   opacity = 1
                                   degrees = 0
                                   positionX = appData.UISW * 0.2
                                   positionY = appData.UISH * 0.4
                                   tiltOffsetX = 0
                                   tiltOffsetY = 0
                               }
                               withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                   tiltOffsetX = 10
                                   tiltOffsetY = 20
                               }
                           }
                       
                       Image(selectedImage)
                           .resizable()
                           .scaledToFit()
                           .frame(width: 130)
                           .position(x: appData.UISW * 0.86, y: appData.UISH * 0.68)
                           .onAppear{
                               dialog = "Primero deberás multiplicar el número que aparezca en la izquierda."
                               self.frame = CGRect(x: appData.UISW * 0.32, y: appData.UISH * 0.2, width: 140, height: 140)
                               if appData.sound {
            //                                    SoundManager.instance.playDialogES(sound: .AR3, loop: false)
                               }
                           }
                       
                       ZStack {
                           Image("triangulo")
                               .resizable()
                               .scaledToFit()
                               .rotationEffect(.degrees(110))
                               .offset(x: 274, y: 10)
                               .frame(width: 20)
                           
                           RoundedRectangle(cornerRadius: 25)
                               .foregroundColor(.white)
                               .frame(width: appData.UISW * 0.5, height: appData.UISH * 0.175)
                           
                           Text(dialog)
                               .font(.custom("RifficFree-Bold", size: 25))
                               .foregroundColor(selectedColor)
                               .frame(width: 500)
                               .multilineTextAlignment(.center)
                       }
                       .position(x: appData.UISW * 0.53, y: appData.UISH * 0.68)
                       
                       Button{
                           withAnimation (.spring(duration: 0.2)){
                               appData.FlagTuto = 22
                               SoundManager.instance.stopDialog()
                           }
                       } label: {
                           Text("Continuar")
                               .font(.custom("RifficFree-Bold", size: 20))
                               .padding(.horizontal)
                               .padding(.vertical, 10)
                               .foregroundColor(.white)
                       }
                           .background(selectedColor)
                           .cornerRadius(8)
                           .position(x: appData.UISW * 0.69, y: appData.UISH * 0.77)
                   } else if appData.FlagTuto == 22 {
                       
                       Rectangle()
                           .foregroundColor(.white.opacity(0.0000000000000001))
                           .frame(width: appData.UISW * 1, height: appData.UISH * 0.14)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.9)
                           .onAppear {
                               withAnimation (.smooth(duration: 0.2)){
                                   opacity = 1
                                   degrees = 230
                                   positionX = appData.UISW * 0.7
                                   positionY = appData.UISH * 0.2
                                   tiltOffsetX = 0
                                   tiltOffsetY = 0
                               }
                               withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                   tiltOffsetX = 20
                                   tiltOffsetY = 0
                               }
                           }
                       
                       Image(selectedImage)
                           .resizable()
                           .scaledToFit()
                           .frame(width: 130)
                           .position(x: appData.UISW * 0.3, y: appData.UISH * 0.68)
                           .onAppear{
                               dialog = "Por las unidades..."
                               self.frame = CGRect(x: appData.UISW * 0.505, y: appData.UISH * 0.2, width: 40, height: 140)
                               if appData.sound {
            //                                    SoundManager.instance.playDialogES(sound: .AR3, loop: false)
                               }
                           }
                       
                       ZStack {
                           Image("triangulo")
                               .resizable()
                               .scaledToFit()
                               .rotationEffect(.degrees(140))
                               .offset(x: -150, y: 10)
                               .frame(width: 20)
                           
                           RoundedRectangle(cornerRadius: 25)
                               .foregroundColor(.white)
                               .frame(width: appData.UISW * 0.25, height: appData.UISH * 0.175)
                           
                           Text(dialog)
                               .font(.custom("RifficFree-Bold", size: 25))
                               .foregroundColor(selectedColor)
                               .frame(width: 500)
                               .multilineTextAlignment(.center)
                       }
                       .position(x: appData.UISW * 0.53, y: appData.UISH * 0.68)
                       
                       Button{
                           withAnimation (.spring(duration: 0.2)){
                               appData.FlagTuto = 23
                               SoundManager.instance.stopDialog()
                           }
                       } label: {
                           Text("Continuar")
                               .font(.custom("RifficFree-Bold", size: 20))
                               .padding(.horizontal)
                               .padding(.vertical, 10)
                               .foregroundColor(.white)
                       }
                           .background(selectedColor)
                           .cornerRadius(8)
                           .position(x: appData.UISW * 0.58, y: appData.UISH * 0.77)
                   } else if appData.FlagTuto == 23 {
                       
                       Rectangle()
                           .foregroundColor(.white.opacity(0.0000000000000001))
                           .frame(width: appData.UISW * 1, height: appData.UISH * 0.14)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.9)
                           .onAppear {
                               withAnimation (.smooth(duration: 0.2)){
                                   opacity = 1
                                   degrees = 230
                                   positionX = appData.UISW * 0.7
                                   positionY = appData.UISH * 0.2
                                   tiltOffsetX = 0
                                   tiltOffsetY = 0
                               }
                               withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                   tiltOffsetX = 20
                                   tiltOffsetY = 0
                               }
                           }
                       
                       Image(selectedImage)
                           .resizable()
                           .scaledToFit()
                           .frame(width: 130)
                           .position(x: appData.UISW * 0.3, y: appData.UISH * 0.68)
                           .onAppear{
                               dialog = "Por las decenas..."
                               self.frame = CGRect(x: appData.UISW * 0.5, y: appData.UISH * 0.2, width: 70, height: 140)
                               if appData.sound {
            //                                    SoundManager.instance.playDialogES(sound: .AR3, loop: false)
                               }
                           }
                       
                       ZStack {
                           Image("triangulo")
                               .resizable()
                               .scaledToFit()
                               .rotationEffect(.degrees(140))
                               .offset(x: -150, y: 10)
                               .frame(width: 20)
                           
                           RoundedRectangle(cornerRadius: 25)
                               .foregroundColor(.white)
                               .frame(width: appData.UISW * 0.25, height: appData.UISH * 0.175)
                           
                           Text(dialog)
                               .font(.custom("RifficFree-Bold", size: 25))
                               .foregroundColor(selectedColor)
                               .frame(width: 500)
                               .multilineTextAlignment(.center)
                       }
                       .position(x: appData.UISW * 0.53, y: appData.UISH * 0.68)
                       
                       Button{
                           withAnimation (.spring(duration: 0.2)){
                               appData.FlagTuto = 24
                               SoundManager.instance.stopDialog()
                           }
                       } label: {
                           Text("Continuar")
                               .font(.custom("RifficFree-Bold", size: 20))
                               .padding(.horizontal)
                               .padding(.vertical, 10)
                               .foregroundColor(.white)
                       }
                           .background(selectedColor)
                           .cornerRadius(8)
                           .position(x: appData.UISW * 0.58, y: appData.UISH * 0.77)
                   } else if appData.FlagTuto == 24 {
                       
                       Rectangle()
                           .foregroundColor(.white.opacity(0.0000000000000001))
                           .frame(width: appData.UISW * 1, height: appData.UISH * 0.14)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.9)
                           .onAppear {
                               withAnimation (.smooth(duration: 0.2)){
                                   opacity = 1
                                   degrees = 230
                                   positionX = appData.UISW * 0.7
                                   positionY = appData.UISH * 0.2
                                   tiltOffsetX = 0
                                   tiltOffsetY = 0
                               }
                               withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                   tiltOffsetX = 20
                                   tiltOffsetY = 0
                               }
                           }
                       
                       Image(selectedImage)
                           .resizable()
                           .scaledToFit()
                           .frame(width: 130)
                           .position(x: appData.UISW * 0.3, y: appData.UISH * 0.68)
                           .onAppear{
                               dialog = "Y por las centenas..."
                               self.frame = CGRect(x: appData.UISW * 0.48, y: appData.UISH * 0.2, width: 140, height: 140)
                               if appData.sound {
            //                                    SoundManager.instance.playDialogES(sound: .AR3, loop: false)
                               }
                           }
                       
                       ZStack {
                           Image("triangulo")
                               .resizable()
                               .scaledToFit()
                               .rotationEffect(.degrees(140))
                               .offset(x: -150, y: 10)
                               .frame(width: 20)
                           
                           RoundedRectangle(cornerRadius: 25)
                               .foregroundColor(.white)
                               .frame(width: appData.UISW * 0.25, height: appData.UISH * 0.175)
                           
                           Text(dialog)
                               .font(.custom("RifficFree-Bold", size: 25))
                               .foregroundColor(selectedColor)
                               .frame(width: 500)
                               .multilineTextAlignment(.center)
                       }
                       .position(x: appData.UISW * 0.53, y: appData.UISH * 0.68)
                       
                       Button{
                           withAnimation (.spring(duration: 0.2)){
                               appData.FlagTuto = 25
                               SoundManager.instance.stopDialog()
                           }
                       } label: {
                           Text("Continuar")
                               .font(.custom("RifficFree-Bold", size: 20))
                               .padding(.horizontal)
                               .padding(.vertical, 10)
                               .foregroundColor(.white)
                       }
                           .background(selectedColor)
                           .cornerRadius(8)
                           .position(x: appData.UISW * 0.58, y: appData.UISH * 0.77)
                   } else if appData.FlagTuto == 25 {
                       
                       Rectangle()
                           .foregroundColor(.white.opacity(0.0000000000000001))
                           .frame(width: appData.UISW * 1, height: appData.UISH * 0.14)
                           .position(x: appData.UISW * 0.5, y: appData.UISH * 0.9)
                           .onAppear {
                               withAnimation (.smooth(duration: 0.2)){
                                   opacity = 1
                                   degrees = 50
                                   positionX = appData.UISW * 0.47
                                   positionY = appData.UISH * 0.2
                                   tiltOffsetX = 0
                                   tiltOffsetY = 0
                               }
                               withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                   tiltOffsetX = 20
                                   tiltOffsetY = 0
                               }
                           }
                       
                       Image(selectedImage)
                           .resizable()
                           .scaledToFit()
                           .frame(width: 130)
                           .position(x: appData.UISW * 0.2, y: appData.UISH * 0.68)
                           .onAppear{
                               dialog = "Para después sumar los resultados y colocarlos sobre el recuadro"
                               self.frame = CGRect(x: appData.UISW * 0.66, y: appData.UISH * 0.2, width: 160, height: 140)
                               if appData.sound {
            //                                    SoundManager.instance.playDialogES(sound: .AR3, loop: false)
                               }
                           }
                       
                       ZStack {
                           Image("triangulo")
                               .resizable()
                               .scaledToFit()
                               .rotationEffect(.degrees(140))
                               .offset(x: -266, y: 10)
                               .frame(width: 20)
                           
                           RoundedRectangle(cornerRadius: 25)
                               .foregroundColor(.white)
                               .frame(width: appData.UISW * 0.45, height: appData.UISH * 0.175)
                           
                           Text(dialog)
                               .font(.custom("RifficFree-Bold", size: 25))
                               .foregroundColor(selectedColor)
                               .frame(width: 500)
                               .multilineTextAlignment(.center)
                       }
                       .position(x: appData.UISW * 0.53, y: appData.UISH * 0.68)
                       
                       Button{
                           withAnimation (.spring(duration: 0.2)){
                               appData.FlagTuto = 14
                               SoundManager.instance.stopDialog()
                           }
                       } label: {
                           Text("Continuar")
                               .font(.custom("RifficFree-Bold", size: 20))
                               .padding(.horizontal)
                               .padding(.vertical, 10)
                               .foregroundColor(.white)
                       }
                           .background(selectedColor)
                           .cornerRadius(8)
                           .position(x: appData.UISW * 0.58, y: appData.UISH * 0.77)
                   }
                    Button{
                        withAnimation(.easeInOut(duration: 0.1)) {
                            appData.sound.toggle()
                        }
                    } label: {
                        Image(appData.sound ? "sound" : "mute")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                           
                    }.position(x: appData.UISW * 0.94, y: appData.UISH * 0.09)
                                    
                }.onAppear{
                    appData.FlagTuto = 19
                }
            }
            
            Image(getHandImage(for: selectedImage))
                .resizable()
                .scaledToFit()
                .frame(width: 130)
                .rotationEffect(.degrees(degrees))
                .position(x: positionX, y: positionY)
                .offset(x: -tiltOffsetX, y: tiltOffsetY)
                .opacity(opacity)
            
//            Text("\(appData.FlagTuto)")
        }
        .ignoresSafeArea()
        .onAppear {
            selectedImage = imageNames.randomElement() ?? "melodyFace"
            selectedColor = getColor(for: selectedImage)
            isEven = perfilesViewModel.perfiles.count % 2 == 0
        }
        .onChange(of: appData.sound) { newValue in
            if newValue {
                SoundManager.instance.resumeActiveSound()
            } else {
                SoundManager.instance.pauseActiveSound()
                SoundManager.instance.stopDialog()
            }
        }
    }
    
    func getColor(for imageName: String) -> Color {
        return colors[imageName] ?? .black
    }
    
    func getHandImage(for imageName: String) -> String {
        return handImages[imageName] ?? "defaultHand"
    }

}

#Preview {
    TutorialView(viewType: .reto)
        .environmentObject(AppData())
        .environmentObject(PerfilesViewModel())
}

