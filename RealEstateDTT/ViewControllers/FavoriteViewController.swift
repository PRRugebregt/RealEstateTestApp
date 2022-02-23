//
//  FavoriteViewController.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    private var locationManager: LocationManager {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.locationManager
        }
        set {}
    }
    var favoriteHouses : [House] {
        get {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.favoriteHouses
        }
        set{}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavorites(_:)), name: .updateHouses, object: nil)
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        favoritesTableView.register(UINib(nibName: "HouseTableViewCell", bundle: nil), forCellReuseIdentifier: "houseTableViewCell")
        favoritesTableView.dequeueReusableCell(withIdentifier: "houseTableViewCell")
        favoritesTableView.rowHeight = 103
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.favoritesTableView.reloadData()
        }
    }
    
    @objc func updateFavorites(_ notification: Notification) {
        print("received data")
        if let houses = notification.userInfo?["houses"] as? [House] {
            favoriteHouses = houses.filter({$0.isFavorite})
            print(favoriteHouses.count)
        }
    }
    
}

extension FavoriteViewController: UITableViewDelegate {
    
}

extension FavoriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteHouses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "houseTableViewCell") as! HouseTableViewCell
        let houseForCell = favoriteHouses[indexPath.row]
        let distanceToUser = locationManager.calculateDistance(latitude: houseForCell.latitude,
                                                               longitude: houseForCell.longitude)
        if let imageData = houseForCell.imageData {
            cell.houseImage.image = UIImage(data: imageData)
        } else {
            cell.houseImage.image = UIImage(named: "home-2")
        }

        let priceString = PriceFormatter.shared.formatPrice(houseForCell.price)
        cell.priceLabel.text = "$\(priceString!)" // Formatted as (1,000,000)
        cell.addressLabel.text = houseForCell.zip + " " + houseForCell.city
        cell.numberOfBathroomLabel.text = String(houseForCell.bathrooms)
        cell.numberOfBedroomLabel.text = String(houseForCell.bedrooms)
        cell.distanceLabel.text = String(distanceToUser)
        cell.squareMetersLabel.text = String(houseForCell.size)
        return cell
    }
    
}

extension Notification.Name {
    static let updateHouses = Notification.Name(rawValue: "updateHouses")
}
