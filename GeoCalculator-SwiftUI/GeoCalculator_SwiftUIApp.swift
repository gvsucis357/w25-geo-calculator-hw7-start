//
//  GeoCalculator_SwiftUIApp.swift
//  GeoCalculator-SwiftUI
//
//  Created by Jonathan Engelsma on 1/30/25.
//

import SwiftUI

@main
struct GeoCalculator_SwiftUIApp: App {
    @StateObject var settings = SettingsViewModel()
    @StateObject var history = HistoryViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .environmentObject(history)
        }
    }
}
