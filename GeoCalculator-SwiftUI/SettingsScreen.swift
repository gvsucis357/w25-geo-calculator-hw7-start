//
//  SettingsScreen.swift
//  GeoCalculator-SwiftUI
//
//  Created by Jonathan Engelsma on 2/18/25.
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var settings: SettingsViewModel
    
    let distUnitStrs: [String] = DistanceUnits.allCases.map { $0.rawValue }
    let bearingUnitStrs: [String] = BearingUnits.allCases.map { $0.rawValue }
    

    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
            SettingsView(settingsName: "Distance Units", values: distUnitStrs)
            SettingsView(settingsName: "Bearing Units", values: bearingUnitStrs)
            Spacer()
        }
    }
}

#Preview {
    SettingsScreen()
        .environmentObject(SettingsViewModel())
}
