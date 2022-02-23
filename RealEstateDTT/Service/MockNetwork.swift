//
//  MockNetwork.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import UIKit

class MockNetwork: NetworkFetchable {
    
    let urlString = "https://intern.docker-dev.d-tt.nl/api/house"
    let accessKey = "98bww4ezuzfePCYFxJEWyszbUXc7dxRx"
    
    var data: Data? {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode([House(id: 0, imageURL: "", descriptionString: "", zip: "", city: "", price: 1000, bedrooms: 1, bathrooms: 1, size: 50, latitude: 50, longitude: 30)])
            return data
        } catch {
            print(error)
        }
        return nil
    }
    var imageData: Data? {
        let jsonEncoder = JSONEncoder()
        do {
            let image = try jsonEncoder.encode("home")
            return image
        } catch {
            print(error)
        }
        return nil
    }
    
    func fetchFromApi(completionHandler: @escaping (_ items: [House]) -> Void) {
        print("Network call started")

                self.decodeData(from: data!) { items in
                    completionHandler(items)
                }
        
    }
    
    func decodeData(from data: Data, completionHandler: (_ items: [House]) -> Void) {
        let decoder = JSONDecoder()
        var decodedData = [House]()
        do {
            decodedData = try decoder.decode([House].self, from: data)

            completionHandler(decodedData)
        } catch {
            print(error)
        }
    }
    
    func fetchImage(imagePath: String, completionHandler: @escaping (_ imageData: Data) -> Void) {
        if imagePath == "image" {
            completionHandler(imageData!)
        }
    }
    
}
