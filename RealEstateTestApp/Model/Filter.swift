//
//  Filter.swift
//  RealEstateTestApp
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import Foundation

class Filter {
    
    var originalHousesList = [House]()
    
    /// Filtering houses that do not contain query in cityname or zipcode.
    /// If query is empty. return original list.
    
    func filter(with query: String) -> [House] {
        guard !query.isEmpty else { return originalHousesList }
        var filteredHouses = originalHousesList
        filteredHouses = filteredHouses.filter({$0.city.lowercased().contains(query.lowercased()) || $0.zip.lowercased().contains(query.lowercased())})
        return filteredHouses
    }
    
}
