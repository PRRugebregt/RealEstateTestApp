//
//  RootTabBarController.swift
//  RealEstateTestApp
//
//  Created by Patrick Rugebregt on 04/03/2022.
//

import UIKit

class RootTabBarController: UITabBarController {

    /// Dependencies to inject
    private let locationManager = LocationManager()
    private let network = MockNetwork() /// Mocknetwork. URLSession fetching code is present in NetworkDownload
    private let coreData = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewControllers = viewControllers else { return }
        /// Works for small app like this. Might have to change this if more views are added
        for viewController in viewControllers {
            switch viewController {
            case let viewController as RootViewController:
                guard let housesViewController = viewController.children[0] as? HousesViewController else { return }
                housesViewController.houseManager = HouseManager(network: network, locationManager: locationManager, houseSaveableToDisk: coreData, houseFetchableFromDisk: coreData)
            case let viewController as FavoriteViewController:
                viewController.locationManager = locationManager
            default:
                break
            }
        }
    }
    


}
