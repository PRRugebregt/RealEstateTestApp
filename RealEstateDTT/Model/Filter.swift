//
//  Filter.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import Foundation

class Filter {
    
    var originalHousesList = [House]()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateHouses(_:)), name: .updateHouses, object: nil)
    }
    
    @objc func updateHouses(_ notification: Notification) {
        print("received data")
        if let houses = notification.userInfo?["houses"] as? [House] {
            originalHousesList = houses
        }
    }
    
    // Filtering houses that do not contain query in cityname or zipcode.
    // If query is empty. return original list.
    
    func filter(with query: String) -> [House] {
        guard !query.isEmpty else { return originalHousesList }
        var filteredHouses = originalHousesList
        filteredHouses = filteredHouses.filter({$0.city.lowercased().contains(query.lowercased()) || $0.zip.lowercased().contains(query.lowercased())})
        return filteredHouses
    }
    
}
