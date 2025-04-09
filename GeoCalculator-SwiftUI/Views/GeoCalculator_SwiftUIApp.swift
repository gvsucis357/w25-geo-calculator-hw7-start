//
//  GeoCalculator_SwiftUIApp.swift
//  GeoCalculator-SwiftUI
//
//  Created by Jonathan Engelsma on 1/30/25.
//

import Firebase
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("ApplicationDelegate didFinishLaunchingWithOptions.")
        FirebaseApp.configure()
        return true
    }
}

@main
struct GeoCalculator_SwiftUIApp: App {
    @StateObject var settings = SettingsViewModel()
    @StateObject var history = HistoryViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .environmentObject(history)
        }
    }
}
