//
// MARK:  Dima_MundoApp.swift
//
///MARK:  Created by Chema Padilla Fdez && Pedro Prado on 07/06/24.
//

import SwiftUI

@main
struct MyApp: App {
    @StateObject private var appData = AppData()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appData)
        }
    }
}
