//
//  LocationManager.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import Foundation
import CoreLocation

protocol LocationManageable {
    func calculateDistance(latitude: Double, longitude: Double) -> Float
    func checkForLocationPermission()
    var currentLocation: CLLocation { get set }
}

class LocationManager: NSObject, LocationManageable {
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation(latitude: 0, longitude: 0)
    
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
    
    // Ask user permission to use location. When either denied or authorized fetch current location.
    func checkForLocationPermission() {
        if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .authorizedWhenInUse {
            fetchCurrentLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func fetchCurrentLocation() {
        locationManager.requestLocation()
        if locationManager.authorizationStatus == .denied {
            currentLocation = CLLocation(latitude: 50, longitude: 50)
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
        
    // Posting notification to load and refresh houses in HousesViewController
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else { return }
        currentLocation = locations[0]
        NotificationCenter.default.post(name: .refreshData, object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        fetchCurrentLocation()
    }
    
}
