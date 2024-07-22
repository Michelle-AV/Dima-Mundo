import SwiftUI
import Combine

class AppData: ObservableObject {
    @Published var UISW: CGFloat = UIScreen.main.bounds.width
    @Published var UISH: CGFloat = UIScreen.main.bounds.height

}

// MARK: - USO DE AppData: ObservableObject

/// Para visualizar los datos en previews:         .environmentObject(AppData())
