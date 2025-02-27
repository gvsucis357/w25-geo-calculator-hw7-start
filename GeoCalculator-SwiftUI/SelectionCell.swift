//
//  SelectionCell.swift
//  GeoCalculator-SwiftUI
//
//  Created by Jonathan Engelsma on 2/27/25.
//

import SwiftUI

struct SelectionCell: View {
    
    let value: String
    @EnvironmentObject var settings: SettingsViewModel
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.0000001)
            HStack {
                Text(value)
                Spacer()
                if value == settings.bearingUnits.rawValue || value == settings.distanceUnits.rawValue {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .onTapGesture {
            switch(value) {
            case "Miles":
                settings.distanceUnits = .miles
            case "Kilometers":
                settings.distanceUnits = .kilometers
            case "Degrees":
                settings.bearingUnits = .degrees
            case "Mils":
                settings.bearingUnits = .mils
            default:
                print("bad val")
            }
        }
    }
}

#Preview {
    SelectionCell(value: "Miles")
        .environmentObject(SettingsViewModel())
        .padding()
}
