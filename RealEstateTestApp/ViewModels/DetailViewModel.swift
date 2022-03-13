//
//  DetailViewModel.swift
//  RealEstateTestApp
//
//  Created by Patrick Rugebregt on 02/03/2022.
//

import Foundation
import CoreLocation
import MapKit

class DetailViewModel {
    
    ///  The selected house
    var chosenHouse: House
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
    
    init(chosenHouse: House) {
        self.chosenHouse = chosenHouse
        center = CLLocationCoordinate2D(latitude: houseAnnotation.coordinate.latitude, longitude: houseAnnotation.coordinate.longitude)
    }
    
    /// Open house address in maps for route
    func openLocationInMaps(from view: MKAnnotationView) {
        guard let houseAnnotation = view.annotation as? HouseAnnotation else { return }
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        houseAnnotation.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
}
