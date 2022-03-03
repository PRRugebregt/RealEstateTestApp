//
//  RootViewController.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 01/03/2022.
//

import UIKit

class RootViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let favoriteController = self.tabBarController?.viewControllers?[2] as! FavoriteViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let locationManager = appDelegate.locationManager
        favoriteController.locationManager = locationManager
    }

}
