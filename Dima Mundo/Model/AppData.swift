import SwiftUI
import Combine

class AppData: ObservableObject {
    @Published var UISW: CGFloat = UIScreen.main.bounds.width
    @Published var UISH: CGFloat = UIScreen.main.bounds.height
    
    @Published var sound: Bool = true
    
    @Published var isTuto: Bool = false
    
    /// 1 = Teclado visible en pantalla
    @Published var FlagTuto: Int = 0
}

// MARK: - USO DE AppData: ObservableObject

/// Para visualizar los datos en previews:         .environmentObject(AppData())
