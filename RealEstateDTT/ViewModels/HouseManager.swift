//
//  HouseManager.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import Foundation

protocol CanUpdateFavorites {
    func updateFavorites()
}

class HouseManager: CanUpdateFavorites {

    private let houseSaveableToDisk: HouseSaveableToDisk
    private let houseFetchableFromDisk: HouseFetchableFromDisk
    private let filter = Filter()
    let locationManager: LocationManageable
    let network: NetworkFetchable
    var chosenHouse: House?
    var chosenDistance: Float = 0
    var houses = [House]() {
        didSet {
            houses.sort(by: {$0.price < $1.price})
            postUpdate()
        }
    }
    
    // Dependency injection through RootViewController
    init(network: NetworkFetchable = NetworkDownload(),
         locationManager: LocationManageable = LocationManager(),
         houseSaveableToDisk: HouseSaveableToDisk = CoreDataManager.shared,
         houseFetchableFromDisk: HouseFetchableFromDisk = CoreDataManager.shared) {
        self.houseSaveableToDisk = houseSaveableToDisk
        self.houseFetchableFromDisk = houseFetchableFromDisk
        self.locationManager = locationManager
        self.network = network
        locationManager.checkForLocationPermission()
        checkForCoreDataObjects()
    }
    
    // Update HouseViewController houses
    func postUpdate() {
        NotificationCenter.default.post(name: .updateHouses, object: nil, userInfo: ["houses":houses])
        NotificationCenter.default.post(name: .refreshData, object: nil)
        print(houses)
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
        for i in houses.indices {
            if houses[i].descriptionString == chosenHouse.descriptionString {
                houses[i].isFavorite = isFavorite
                break
            }
        }
    }
    
    // Filter houses by query
    func filter(with query: String) {
        houses = filter.filter(with: query)
    }
    
    // Chosen house for detail view
    func chooseHouse(with index: Int) {
        chosenHouse = houses[index]
        guard let chosenHouse = chosenHouse else { return }
        chosenDistance = locationManager.calculateDistance(latitude: chosenHouse.latitude, longitude: chosenHouse.longitude)
    }
    
    // update isFavorite boolean for FavoritesViewController list
    func updateFavorites() {
        guard let chosenHouse = chosenHouse else { return }
        for i in houses.indices {
            if houses[i].descriptionString == chosenHouse.descriptionString {
                houses[i].isFavorite.toggle()
                break
            }
        }
    }
    
}
