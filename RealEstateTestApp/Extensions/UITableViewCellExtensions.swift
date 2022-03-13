//
//  UITableViewCellExtensions.swift
//  RealEstateTestApp
//
//  Created by Patrick Rugebregt on 24/02/2022.
//

import UIKit

extension UITableViewCell {
    
    /// To create our custom House Cell I made this static func
    static func createCustomHouseCell(for tableView: UITableView, houses: [House], locationManager: LocationManageable?, row: Int) -> HouseTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "houseTableViewCell") as! HouseTableViewCell
        let houseForCell = houses[row]
        let distanceToUser = locationManager?.calculateDistance(latitude: houseForCell.latitude,
                                                                longitude: houseForCell.longitude) ?? 0
        let distanceInKm = distanceToUser / 1000
        if let imageData = houseForCell.imageData {
            cell.houseImage.image = UIImage(data: imageData)
        } else {
            cell.houseImage.image = UIImage(named: "home-2")
        }
        let priceString = PriceFormatter.shared.formatPrice(houseForCell.price)
        cell.priceLabel.text = "$\(priceString!)" // Formatted as (1,000,000)
        cell.addressLabel.text = houseForCell.zip + " " + houseForCell.city
        cell.numberOfBathroomLabel.text = String(houseForCell.bathrooms)
        cell.numberOfBedroomLabel.text = String(houseForCell.bedrooms)
        cell.distanceLabel.text = "\(String(format: "%.2f", distanceInKm)) km"
        cell.squareMetersLabel.text = String(houseForCell.size)
        return cell
    }
    
}
