//
//  MockNetwork.swift
//  RealEstateTestApp
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import UIKit

class MockNetwork: NetworkFetchable {
    
    /// Fetching a JSON from bundle URL for testing purposes
    func fetchFromApi(completionHandler: @escaping (_ items: [House]) -> Void) {
        print("Network call started")
        let session = URLSession.shared
        guard let url = Constants.url else { return }
        var request = URLRequest(url: url)
        request.addValue(Constants.accessKey, forHTTPHeaderField: "Access-Key")
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let data = data {
                self.decodeData(from: data) { items in
                    completionHandler(items)
                }
            }
        }.resume()
    }
    
    /// Decoding data into house array
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
    
    /// Seperate images fetching
    func fetchImage(imagePath: String, completionHandler: @escaping (_ imageData: Data) -> Void) {
        print(imagePath)
            let image = UIImage(named: "\(imagePath.replacingOccurrences(of: ".jpeg", with: "", options: .caseInsensitive, range: nil))")
        print(image == nil)
            if let imageData = image?.jpegData(compressionQuality: 1) {
                completionHandler(imageData)
            }

    }
    
}
