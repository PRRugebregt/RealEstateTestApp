//
//  HouseManager.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import Foundation

class HouseManager {

    private let houseSaveableToDisk: HouseSaveableToDisk
    private let houseFetchableFromDisk: HouseFetchableFromDisk
    private let filter = Filter()
    let locationManager: LocationManageable
    let network: NetworkFetchable
    var chosenHouse: House?
    var chosenDistance: Float = 0
    
    private var houses = [House]() {
        didSet {
            houses.sort(by: {$0.price < $1.price})
            postUpdate()
        }
    }
    
    // Dependency injection through RootViewController
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
    
    // Update HouseViewController houses
    func postUpdate() {
        NotificationCenter.default.post(name: .updateHouses, object: nil, userInfo: ["houses":houses])
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
    }
    
    // Network call for houselist 
    func downloadHouses() {
        network.fetchFromApi { items in
            self.houses = items
            self.downloadImages()
        }
    }
    
    /* not very elegant but making sure saving Coredata context only gets called once every image is loaded
    with count == self.houses.count. Refreshing list everytime new image is loaded
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
        houseSaveableToDisk.updateCoreDataHouse(descriptionString: chosenHouse.descriptionString, isFavorite: isFavorite)
    }
    
    // Filter houses by query
    func filter(with query: String) {
        houses = filter.filter(with: query)
    }
    
    // Chosen house for detail view
    func chooseHouse(_ house: House) {
        chosenHouse = house
        chosenDistance = locationManager.calculateDistance(latitude: house.latitude, longitude: house.longitude)
    }
    
}
