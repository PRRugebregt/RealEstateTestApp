//
//  HousesViewController.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 22/02/2022.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let housesViewController = self.children[0] as! HousesViewController
        housesViewController.network = NetworkDownload()
    }


}
