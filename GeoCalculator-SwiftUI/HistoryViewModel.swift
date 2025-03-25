//
//  HistoryViewModel.swift
//  GeoCalculator-SwiftUI
//
//  Created by Jonathan Engelsma on 3/12/25.
//

import SwiftUI

struct Calculation: Identifiable {
    var id = UUID()
    var lat1: Double
    var lng1: Double
    var lat2: Double
    var lng2: Double
    var time: Date
    var distanceUnits: DistanceUnits
    var bearingUnits: BearingUnits
}

class HistoryViewModel: ObservableObject {
    @Published var history: [Calculation] = []
    @Published var selected: Calculation? = nil
}
