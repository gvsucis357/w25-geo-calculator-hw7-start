//
//  ContentView.swift
//  GeoCalculator-SwiftUI
//
//  Created by Jonathan Engelsma on 1/30/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var history: HistoryViewModel
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 6
        return formatter
    }()
    enum FocusedField {
        case lat1, lng1, lat2, lng2
    }
    @State private var lat1:Double?
    @State private var lng1: Double?
    @State private var lat2: Double?
    @State private var lng2: Double?
    @State private var distanceStr = ""
    @State private var bearingStr = ""
    @FocusState private var focusedField: FocusedField?
    var body: some View {
        NavigationStack() {
            ZStack {
                Color.white.opacity(0.0000001)
                VStack {
                    HStack {
                        TextField("Enter latitude", value: $lat1, formatter: numberFormatter)
                            .focused($focusedField, equals: .lat1)
                        TextField("Enter longitude", value: $lng1, formatter: numberFormatter)
                            .focused($focusedField, equals: .lng1)
                    }
                    
                    HStack {
                        TextField("Enter latitude", value: $lat2, formatter: numberFormatter)
                            .focused($focusedField, equals: .lat2)
                        TextField("Enter longitude", value: $lng2, formatter: numberFormatter)
                            .focused($focusedField, equals: .lng2)
                    }
                    HStack {
                        Button("Calculate") {
                            doCalculations()
                            focusedField = nil
                        }
                        .disabled(lat1?.isNaN ?? true || lng1?.isNaN ?? true || lat2?.isNaN ?? true || lng2?.isNaN ?? true)
                        Spacer()
                        Button("Clear") {
                            lat1 = nil
                            lat2 = nil
                            lng1 = nil
                            lng2 = nil
                            focusedField = nil
                            distanceStr = ""
                            bearingStr = ""
                        }
                        
                    }
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        Text(distanceStr)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack{
                        Text(bearingStr)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    Spacer()
                }
                .onAppear() {
                    if let calc = history.selected {
                        lat1 = calc.lat1
                        lng1 = calc.lng1
                        lat2 = calc.lat2
                        lng2 = calc.lng2
                        settings.distanceUnits = calc.distanceUnits
                        settings.bearingUnits = calc.bearingUnits
                        history.selected = nil
                    }
                    doCalculations()
                }
                .textFieldStyle(SignedDecimalFieldStyle())
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        
                        // minus toggle button
                        Button {
                            switch(focusedField) {
                            case .lat1:
                                if let l = lat1 {
                                    lat1 = l * -1
                                }
                            case .lng1:
                                if let l = lng1 {
                                    lng1 = l * -1
                                }
                            case .lat2:
                                if let l = lat2 {
                                    lat2 = l * -1
                                }
                            case .lng2:
                                if let l = lng2 {
                                    lng2 = l * -1
                                }
                            default:
                                break
                            }
                            
                        } label: {
                            Image(systemName: "minus.square")
                        }
                    }
                    ToolbarItem(placement: .keyboard) {
                        Spacer()
                    }
                    ToolbarItem(placement: .keyboard) {
                        
                        // keyboard dismiss button
                        Button {
                            focusedField = nil
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
                }
                .padding()
            }
            .onTapGesture {
                print("Tap")
                focusedField = nil
            }
            .navigationTitle("Geo Calculator")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink("History", destination: HistoryScreen())
                        .isDetailLink(false)
                }
    
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Settings", destination: SettingsScreen())
                }
            }
            .onAppear() {
                print("listening for firebase updates...")
                listenForHistoryUpdates(vm: history)
            }
            .onDisappear() {
                print("no longer listening for firebase updates...")
                stopListeningForHistoryUpdates()
            }
        }
    }

    func doCalculations()
    {
        guard let p1lt = lat1, let p1ln = lng1, let p2lt = lat2, let p2ln = lng2  else {
            return
        }
        print("(\(p1lt),\(p1ln)) -- (\(p2lt), \(p2ln))")
        let p1 = CLLocation(latitude: p1lt, longitude: p1ln)
        let p2 = CLLocation(latitude: p2lt, longitude: p2ln)
        
        var distance = p1.distance(from: p2) / 10.0
        
        if settings.distanceUnits == .miles {
            distance = (distance * 0.621371).roundedToTwoDecimals()
        }
        
        distanceStr = "Distance: \(distance.rounded() / 100.0) \(settings.distanceUnits.rawValue)"
        
        var bearing = (p1.bearingToPoint(point: p2) * 100.0).rounded() / 100.0
        
        if settings.bearingUnits == .mils {
            bearing = (bearing * 17.78).roundedToTwoDecimals()
        }
        bearingStr = "Bearing: \(bearing) \(settings.bearingUnits.rawValue)"
        
        // store in history
//        history.history.append(Calculation(lat1: p1lt, lng1: p1ln, lat2: p2lt, lng2: p2ln, time: Date(), distanceUnits: settings.distanceUnits, bearingUnits: settings.bearingUnits))
        Task {
            await addHistory(calculation: Calculation(lat1: p1lt, lng1: p1ln, lat2: p2lt, lng2: p2ln, time: Date(), distanceUnits: settings.distanceUnits, bearingUnits: settings.bearingUnits))
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(SettingsViewModel())
        .environmentObject(HistoryViewModel())
}


extension Double {
    func roundedToTwoDecimals() -> Double {
        return (self * 100).rounded() / 100
    }
}
