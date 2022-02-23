//
//  HouseAnnotation.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import Foundation
import MapKit
import Contacts

class HouseAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let zip: String
    let city: String
    
    var mapItem: MKMapItem? {
      let addressDictionary = [CNPostalAddressStreetKey: zip,
                           CNPostalAddressCityKey: city]
      let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = title
      return mapItem
    }
    
    init(title: String, coordinate: CLLocationCoordinate2D, zip: String, city: String) {
        self.title = title
        self.coordinate = coordinate
        self.zip = zip
        self.city = city
    }
}
