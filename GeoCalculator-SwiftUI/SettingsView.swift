//
//  SettingsView.swift
//  GeoCalculator-SwiftUI
//
//  Created by Jonathan Engelsma on 2/18/25.
//
// based on: https://stackoverflow.com/questions/58613503/how-to-make-list-with-single-selection-with-swiftui

import SwiftUI

struct SettingsView: View {
    var settingsName: String
    var values : [String]
    @State var selectedValue: String? = "Miles"
    @ObservedObject var settings: SettingsViewModel
    
    init(settingsName:String, values: [String], settings: SettingsViewModel) {
        self.settingsName = settingsName
        self.values = values
        self.settings = settings
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(settingsName)
                    .bold()
                Spacer()
            }
            .padding()
            List {
                ForEach(values, id: \.self) { item in
                    SelectionCell(value: item, settings: settings)
                }
            }
        }
        //.scrollContentBackground(.hidden)
        //.background(.gray)
    }
}

struct SelectionCell: View {
    
    let value: String
    @ObservedObject var settings: SettingsViewModel
//    @Binding var selectedValue: String?
    
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
//            self.selectedValue = self.value
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
    @Previewable @StateObject var settings = SettingsViewModel()
    SettingsView( settingsName: "Distance Units", values: ["Miles", "Kilometers"], settings: settings)
}
