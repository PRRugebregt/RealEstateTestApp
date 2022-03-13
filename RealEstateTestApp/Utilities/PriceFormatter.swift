//
//  NumberFormatter.swift
//  RealEstateTestApp
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
    
    // Format price in 1,000,000
    func formatPrice(_ price: Int) -> String? {
        numberFormatter.string(from: NSNumber(integerLiteral: price))
    }
    
}
