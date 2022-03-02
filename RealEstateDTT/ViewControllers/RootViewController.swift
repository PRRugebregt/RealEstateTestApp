//
//  RootViewController.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 01/03/2022.
//

import UIKit

class RootViewController: UINavigationController {

    private var locationManager: LocationManageable!
    private var network: NetworkFetchable!
    private var houseManager: HouseManager!
    private var coreData = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.locationManager = appDelegate.locationManager
        self.network = appDelegate.network
        houseManager = HouseManager(network: network, locationManager: locationManager, houseSaveableToDisk: coreData, houseFetchableFromDisk: coreData)
        print(self.children)
        let houseViewController = children[0] as! HousesViewController
        houseViewController.houseManager = houseManager
        houseViewController.locationManager = locationManager
        let favoriteController = self.tabBarController?.viewControllers?[2] as! FavoriteViewController
        favoriteController.locationManager = locationManager
    }

}
