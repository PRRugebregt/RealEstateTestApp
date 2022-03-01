//
//  Network.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 22/02/2022.
//

import UIKit

protocol NetworkFetchable {
    func fetchFromApi(completionHandler: @escaping (_ items: [House]) -> Void)
    func fetchImage(imagePath: String, completionHandler: @escaping (_ imageData: Data) -> Void)
}

class NetworkDownload: NetworkFetchable {
    
    func fetchFromApi(completionHandler: @escaping (_ items: [House]) -> Void) {
        print("Network call started")
        let session = URLSession.shared
        let url = URL(string: Constants.url)
        guard url != nil else {
            print("URL = nil")
            return
        }
        var request = URLRequest(url: url!)
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
        let session = URLSession(configuration: .default)
        let url = URL(string: Constants.url)!
        let relativeUrl = URL(string: imagePath, relativeTo: url)
        var request = URLRequest(url: relativeUrl!)
        request.addValue(Constants.accessKey, forHTTPHeaderField: "Access-Key")
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let imageData = data {
                completionHandler(imageData as Data)
            }
        }.resume()
    }
    
}
