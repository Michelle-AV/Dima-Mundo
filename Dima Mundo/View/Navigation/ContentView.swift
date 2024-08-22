import SwiftUI
import RiveRuntime

struct ContentView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var perfilesViewModel: PerfilesViewModel
    
    @State private var isSplashScreenActive = true // Variable para controlar la visualización de la splash screen
    
    var body: some View {
        ZStack {
            // Main View
            MainView()
                .environmentObject(appData)
                .environmentObject(PerfilesViewModel())
                .position(x: appData.UISW * 0.5, y: appData.UISH * 0.5)
            
            
            RiveViewModel(fileName: "splashScreen", stateMachineName: "Actions").view()
                .scaleEffect(1.1)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
        .ignoresSafeArea()
    }
}

#Preview{
    ContentView()
        .environmentObject(AppData())
        .environmentObject(PerfilesViewModel())
}
