//
//  HistoryScreen.swift
//  GeoCalculator-SwiftUI
//
//  Created by Jonathan Engelsma on 3/12/25.
//

import SwiftUI

struct HistoryScreen: View {
    @EnvironmentObject var history: HistoryViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Past Calculations")
                .font(.title)
            List(history.history) { calculation in
                VStack {
                    NavigationLink {
                    } label: {
                        VStack {
                            HStack {
                                Text("P1: (\(calculation.lat1),\(calculation.lng1))")
                                Spacer()
                            }
                            HStack {
                                Text("P2: (\(calculation.lat2),\(calculation.lng2))")
                                Spacer()
                            }
                            HStack {
                                Text("Units: \(calculation.distanceUnits), \(calculation.bearingUnits)")
                                Spacer()
                            }
                            Text("\(calculation.time)")
                                .italic()
                        }
                    }
                }
                .simultaneousGesture(TapGesture().onEnded{
                    print("Got Tap")
                    history.selected = calculation
                    dismiss()
                })
            }
        }
    }
}

#Preview {
    HistoryScreen()
        .environmentObject(HistoryViewModel())
}
