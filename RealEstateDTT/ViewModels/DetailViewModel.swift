//
//  DetailViewModel.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 02/03/2022.
//

import Foundation
import CoreLocation
import MapKit

class DetailViewModel {
    
    private var chosenHouse: House
    private let houseSaveableToDisk: HouseSaveableToDisk
    var houseAnnotation: HouseAnnotation {
            let zip = chosenHouse.zip
            let city = chosenHouse.city
            let coordinate = CLLocationCoordinate2D(latitude: chosenHouse.latitude,
                                                    longitude: chosenHouse.longitude)
            return HouseAnnotation(title: "\(city), \(zip)",
                                   coordinate: coordinate,
                                   zip: zip,
                                   city: city)
    }
    var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    init(chosenHouse: House, houseSaveableToDisk: HouseSaveableToDisk = CoreDataManager()) {
        self.chosenHouse = chosenHouse
        self.houseSaveableToDisk = houseSaveableToDisk
        center = CLLocationCoordinate2D(latitude: houseAnnotation.coordinate.latitude, longitude: houseAnnotation.coordinate.longitude)
    }
    
    // Using description as a unique identifier for now
    func updateHouse(_ chosenHouse: House, isFavorite: Bool) {
        houseSaveableToDisk.updateCoreDataHouse(descriptionString: chosenHouse.descriptionString, isFavorite: isFavorite)
    }
    
    func openLocationInMaps(from view: MKAnnotationView) {
        guard let houseAnnotation = view.annotation as? HouseAnnotation else { return }
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        houseAnnotation.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
}
