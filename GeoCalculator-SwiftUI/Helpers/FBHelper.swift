//
//  FBHelper.swift
//  GeoCalculator-SwiftUI
//
//  Created by Jonathan Engelsma on 3/25/25.
//

import FirebaseFirestore
import Foundation

let db = Firestore.firestore()

var listener : ListenerRegistration? = nil

func addHistory(calculation: Calculation) async {
    do {
        try await db.collection("history").document(calculation.id.uuidString).setData([
            "lat1": calculation.lat1,
            "lng1": calculation.lng1,
            "lat2": calculation.lat2,
            "lng2": calculation.lng2,
            "time": calculation.time,
            "distanceUnits": calculation.distanceUnits.rawValue,
            "bearingUnits": calculation.bearingUnits.rawValue
        ])
        print("Document sucessfully written")
    } catch {
        print("Error adding reminder to Firebase!: \(error)")
    }
}


func listenForHistoryUpdates(vm: HistoryViewModel) {
    listener = db.collection("history")
        .addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            var parsedHistory = [Calculation]()
            for document in documents {
                let id = document.documentID
                let data = document.data()
                let lat1 = data["lat1"] as? Double ?? 0.0
                let lng1 = data["lng1"] as? Double ?? 0.0
                let lat2 = data["lat2"] as? Double ?? 0.0
                let lng2 = data["lng2"] as? Double ?? 0.0
                let dStr = data["distanceUnits"] as? String ?? "Kilometers"
                let distanceUnits = DistanceUnits(rawValue: dStr)
                let bStr = data["bearingUnits"] as? String ?? "Degrees"
                let bearingUnits = BearingUnits(rawValue: bStr)
                //let time = data["done"] as? Bool ?? false
                let calculation = Calculation(id: UUID(uuidString: id) ?? UUID(), lat1: lat1, lng1: lng1, lat2: lat2, lng2: lng2, time: Date(), distanceUnits: distanceUnits ?? .kilometers, bearingUnits: bearingUnits ?? .degrees)
                parsedHistory.append(calculation)
            }
            print("read \(parsedHistory.count) reminders")
            Task { @MainActor in
                vm.history = parsedHistory  // update must be done on the @MainActor
            }
        }
}

func stopListeningForHistoryUpdates() {
    if let l = listener {
        l.remove()
    }
}

