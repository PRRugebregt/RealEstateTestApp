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
    private var coreData = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let favoriteController = self.tabBarController?.viewControllers?[2] as! FavoriteViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.locationManager = appDelegate.locationManager
        self.network = appDelegate.network
        favoriteController.locationManager = locationManager
    }

}
