//
//  NumberFormatter.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import Foundation

class PriceFormatter {
    static let shared = PriceFormatter()
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    
    func formatPrice(_ price: Int) -> String? {
        numberFormatter.string(from: NSNumber(integerLiteral: price))
    }
    
}
