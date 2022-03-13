//
//  HouseManager.swift
//  RealEstateTestApp
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import Foundation
import UIKit

class HouseManager {

    private let houseSaveableToDisk: HouseSaveableToDisk
    private let houseFetchableFromDisk: HouseFetchableFromDisk
    private let filter = Filter()
    let locationManager: LocationManageable
    let network: NetworkFetchable
    var chosenHouse: House?
    var chosenDistance: Float = 0
    var houses : Observable<[House]> = Observable([]) {
        didSet {
            houses.value.sort(by: {$0.price < $1.price})
            postUpdate()
        }
    }
    
    init(network: NetworkFetchable,
         locationManager: LocationManageable,
         houseSaveableToDisk: HouseSaveableToDisk,
         houseFetchableFromDisk: HouseFetchableFromDisk) {
        self.houseSaveableToDisk = houseSaveableToDisk
        self.houseFetchableFromDisk = houseFetchableFromDisk
        self.locationManager = locationManager
        self.network = network
        locationManager.checkForLocationPermission()
        checkForCoreDataObjects()
    }
    
    /// Update HouseViewController houses
    func postUpdate() {
        print("Posting update")
        NotificationCenter.default.post(name: .updateHouses, object: nil, userInfo: ["houses":houses])
    }
    
    /// When houses haven't been saved to CoreData yet, fetch them from network, else load them from coredata
    func checkForCoreDataObjects() {
        let fetchedObjects = houseFetchableFromDisk.fetchHouses()
        guard !fetchedObjects.isEmpty else {
            downloadHouses()
            return
        }
        print("Loaded from coredata")
        houses.value = fetchedObjects
        filter.originalHousesList = fetchedObjects
    }
    
    /// Network call for houselist
    func downloadHouses() {
        network.fetchFromApi { items in
            self.houses.value = items
            self.filter.originalHousesList = items
            self.downloadImages()
        }
    }
    
    /* not very elegant but making sure saving Coredata context only gets called once every image is loaded
    with count == self.houses.count. Refreshing list everytime new image is loaded
     */
    func downloadImages() {
        var count = 0
        for i in houses.value.indices {
            network.fetchImage(imagePath: houses.value[i].imageURL) { imageData in
                count += 1
                self.houses.value[i].imageData = imageData
                if count == self.houses.value.count {
                    self.houseSaveableToDisk.saveHouses(self.houses.value)
                }
            }
        }
    }
    
    /// Using description as a unique identifier for now
    func updateHouse(_ chosenHouse: House, isFavorite: Bool) {
        print("updating favorites in hosuemanager")
        houseSaveableToDisk.updateCoreDataHouse(descriptionString: chosenHouse.descriptionString, isFavorite: isFavorite)
        for i in houses.value.indices {
            if houses.value[i].descriptionString == chosenHouse.descriptionString {
                houses.value[i].isFavorite = isFavorite
                break
            }
        }
    }
    
    /// Filter houses by query
    func filter(with query: String) {
        houses.value = filter.filter(with: query)
    }
    
    /// Chosen house for detail view
    func chooseHouse(with index: Int) {
        chosenHouse = houses.value[index]
        guard let chosenHouse = chosenHouse else { return }
        chosenDistance = locationManager.calculateDistance(latitude: chosenHouse.latitude, longitude: chosenHouse.longitude)
    }
    
}
