//
//  AboutViewController.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 22/02/2022.
//

import UIKit

class InfoViewController: UIViewController {

    private var infoViewModel = InfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .dttLightGray
    }

    @IBAction func linkPressed(_ sender: UIButton) {
        infoViewModel.openDTTWebsite()
    }
    
}
