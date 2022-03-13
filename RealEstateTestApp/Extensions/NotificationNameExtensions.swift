//
//  NotificationNameExtensions.swift
//  RealEstateTestApp
//
//  Created by Patrick Rugebregt on 24/02/2022.
//

import Foundation

extension Notification.Name {
    /// Notifications to update favorites list and refresh tableview when location is found
    static let updateHouses = Notification.Name(rawValue: "updateHouses")
    static let refreshData = Notification.Name(rawValue: "refreshData")
}
