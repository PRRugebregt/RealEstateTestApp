//
//  LocationManager.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation(latitude: 0, longitude: 0)
    var delegate: HousesViewController?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // Calculate distance from user location to house with coordinates
    func calculateDistance(latitude: Double, longitude: Double) -> Float {
        let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees( longitude))
        let distance = currentLocation.distance(from: location)
        let distanceFloat = Float(distance)
        return distanceFloat
    }
    
    func fetchCurrentLocation() {
        locationManager.requestLocation()
        if locationManager.authorizationStatus == .denied {
            currentLocation = CLLocation(latitude: 50, longitude: 50)
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else { return }
        currentLocation = locations[0]
        delegate?.refreshTable()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        fetchCurrentLocation()
        delegate?.loadData()
    }
    
}
