//
//  Houses.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 22/02/2022.
//

import Foundation
import UIKit

struct Houses {
    
    var all: [House]
    
}

struct House: Codable, Identifiable {
    
    let id: Int
    let imageURL: String
    let descriptionString: String
    let zip: String
    let city: String
    let price: Int
    let bedrooms: Int
    let bathrooms: Int
    let size: Int
    let latitude: Double
    let longitude: Double
    var imageData: Data?
    var isFavorite = false
    
    // descriptionString was necessary to convert to CoreDataObject.
    // Providing codingkeys to work with Network Api
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image"
        case descriptionString = "description"
        case zip
        case city
        case price
        case bedrooms
        case bathrooms
        case size
        case latitude
        case longitude
    }

}
