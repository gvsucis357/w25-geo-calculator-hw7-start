//
//  SettingsSheet.swift
//  GeoCalculator-SwiftUI
//
//  Created by Jonathan Engelsma on 2/18/25.
//

import SwiftUI

struct SettingsSheet: View {
    @Binding var settingsSheetShown: Bool
    @ObservedObject var settings: SettingsViewModel
    
    let distUnitStrs: [String] = DistanceUnits.allCases.map { $0.rawValue }
    let bearingUnitStrs: [String] = BearingUnits.allCases.map { $0.rawValue }
    

    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
            SettingsView(settingsName: "Distance Units", values: distUnitStrs, settings: settings)
            SettingsView(settingsName: "Bearing Units", values: bearingUnitStrs, settings: settings )
            Spacer()
            Button("Dismiss") {
                settingsSheetShown = false
            }
        }
    }
}

#Preview {
    @Previewable @State var settingsSheetShown: Bool = true
    @Previewable @StateObject var settings = SettingsViewModel()
    SettingsSheet(settingsSheetShown: $settingsSheetShown, settings: settings)
}
