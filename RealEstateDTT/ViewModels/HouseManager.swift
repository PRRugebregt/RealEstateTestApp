//
//  HouseManager.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import Foundation

class HouseManager {

    let locationManager: LocationManageable
    let network: NetworkFetchable
    private let houseSaveableToDisk: HouseSaveableToDisk
    private let houseFetchableFromDisk: HouseFetchableFromDisk
    private let filter = Filter()
    var chosenHouse: House?
    var chosenDistance: Float = 0
    
    private var houses = [House]() {
        didSet {
            NotificationCenter.default.post(name: .updateHouses, object: nil, userInfo: ["houses":houses])
        }
    }
    
    init(network: NetworkFetchable,
         locationManager: LocationManageable,
         houseSaveableToDisk: HouseSaveableToDisk = CoreDataManager(),
         houseFetchableFromDisk: HouseFetchableFromDisk = CoreDataManager()) {
        self.houseSaveableToDisk = houseSaveableToDisk
        self.houseFetchableFromDisk = houseFetchableFromDisk
        self.locationManager = locationManager
        self.network = network
        checkForCoreDataObjects()
        locationManager.checkForLocationPermission()
    }
    
    // When houses haven't been saved to CoreData yet, fetch them from network, else load them from coredata
    func checkForCoreDataObjects() {
        let fetchedObjects = houseFetchableFromDisk.fetchHouses()
        guard !fetchedObjects.isEmpty else {
            downloadHouses()
            return
        }
        print("Loaded from coredata")
        houses = fetchedObjects
        print(houses)
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
                    self.houseSaveableToDisk.saveHouses(self.houses)
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
                houseSaveableToDisk.updateCoreDataHouse(descriptionString: houses[i].descriptionString, isFavorite: isFavorite)
                break
            }
        }
    }
    
    // filter houses by query
    func filter(with query: String) {
        houses = filter.filter(with: query)
    }
    
    func chooseHouse(_ house: House) {
        chosenHouse = house
        chosenDistance = locationManager.calculateDistance(latitude: house.latitude,
                                                            longitude: house.longitude)
    }
    
}
