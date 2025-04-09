//
//  SignedDecimalFieldStyle.swift
//  GeoCalculator-SwiftUI
//
//  Created by Jonathan Engelsma on 2/10/25.
//
import SwiftUI

struct SignedDecimalFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textFieldStyle(.roundedBorder)
            .keyboardType(.decimalPad)
    }
}
