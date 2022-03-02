//
//  AboutViewController.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 22/02/2022.
//

import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .dttLightGray
    }

    @IBAction func linkPressed(_ sender: UIButton) {
        guard let url = URL(string: Constants.dttURL) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
