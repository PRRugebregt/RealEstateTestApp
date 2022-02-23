//
//  HouseManager.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import Foundation

class HouseManager {
    
    let network: NetworkFetchable
    private var houses = [House]() {
        didSet {
            NotificationCenter.default.post(name: .updateHouses, object: nil, userInfo: ["houses":houses])
        }
    }
    
    init(network: NetworkFetchable) {
        self.network = network
    }
    
    // When houses haven't been saved to CoreData yet, fetch them from network, else load them from coredata
    func checkForCoreDataObjects() {
        let fetchedObjects = CoreDataManager.shared.fetchHouses()
        guard !fetchedObjects.isEmpty else {
            downloadHouses()
            return
        }
        print("Loaded from coredata")
        houses = fetchedObjects
    }
    
    func downloadHouses() {
        network.fetchFromApi { items in
            self.houses = items
            self.downloadImages()
        }
    }
    
    /* not very elegant but making sure reloadData() only gets called once every image is loaded
    with count == self.houses.count
     */
    func downloadImages() {
        var count = 0
        for i in houses.indices {
            network.fetchImage(imagePath: houses[i].imageURL) { imageData in
                count += 1
                self.houses[i].imageData = imageData
                if count == self.houses.count {
                    CoreDataManager.shared.saveHouses(self.houses)
                }
            }
        }
    }
    
    // Using description as a unique identifier for now
    func updateHouse(_ chosenHouse: House, isFavorite: Bool) {
        for i in houses.indices {
            if houses[i].descriptionString == chosenHouse.descriptionString {
                print("Found")
                houses[i].isFavorite = isFavorite
                CoreDataManager.shared.updateCoreDataHouse(description: houses[i].descriptionString, isFavorite: isFavorite)
                break
            }
        }
    }
    
}
