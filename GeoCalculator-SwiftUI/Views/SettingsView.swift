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
    @EnvironmentObject var settings: SettingsViewModel
    
    init(settingsName:String, values: [String]) {
        self.settingsName = settingsName
        self.values = values
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
                    SelectionCell(value: item)
                }
            }
        }
    }
}



#Preview {
    @Previewable @StateObject var settings = SettingsViewModel()
    SettingsView( settingsName: "Distance Units", values: ["Miles", "Kilometers"])
        .environmentObject(SettingsViewModel())
}
