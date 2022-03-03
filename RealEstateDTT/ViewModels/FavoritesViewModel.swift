//
//  FavoritesViewModel.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 01/03/2022.
//

import Foundation
import UIKit

class FavoritesViewModel {
    
    // observer not added in time, so taking default list from AppDelegate
    var houses: [House] = []
//    {
//        get {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            return appDelegate.houses.filter({$0.isFavorite})
//        }
//        set {}
//    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavorites(_:)), name: .updateHouses, object: nil)
    }
    
    // Responding to Notification from HouseManager. Filtering results for favorites list.
    @objc func updateFavorites(_ notification: Notification) {
        print("received notification in favoritesViewController")
        if let houses = notification.userInfo?["houses"] as? [House] {
            self.houses = houses.filter({$0.isFavorite})
        }
    }
        
}
