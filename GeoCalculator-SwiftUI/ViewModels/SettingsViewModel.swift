//
//  SettingsViewModel.swift
//  GeoCalculator-SwiftUI
//
//  Created by Jonathan Engelsma on 2/19/25.
//

import SwiftUI

enum DistanceUnits : String, CaseIterable {
    case kilometers = "Kilometers"
    case miles = "Miles"
}

enum BearingUnits : String, CaseIterable {
    case degrees = "Degrees"
    case mils = "Mils"
}

class SettingsViewModel: ObservableObject {
    @Published var distanceUnits: DistanceUnits = .kilometers
    @Published var bearingUnits: BearingUnits = .degrees
}
