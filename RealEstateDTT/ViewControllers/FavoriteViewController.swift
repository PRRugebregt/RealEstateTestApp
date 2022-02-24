//
//  FavoriteViewController.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 23/02/2022.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    private var chosenHouse: House?
    private var chosenDistance: Float = 0
    var houseManager: HouseManager!
    // Using same locationManager to avoid 2 locationManagers
    private var locationManager: LocationManager {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.locationManager
        }
        set {}
    }
    // Fetching houses from AppDelegate the first time, since this class is
    // not yet subscribed to the notification
    var favoriteHouses : [House] {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.houses.filter({$0.isFavorite})
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
        favoritesTableView.rowHeight = 110
    }
    
    // Making sure list is up to date
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.favoritesTableView.reloadData()
        }
    }
    
    // Responding to Notification from HouseManager. Filtering results for favorites list.
    @objc func updateFavorites(_ notification: Notification) {
        print("received notification in favoritesViewController")
        if let houses = notification.userInfo?["houses"] as? [House] {
            favoriteHouses = houses.filter({$0.isFavorite})
            print(favoriteHouses.count)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailViewController
        destination.chosenHouse = chosenHouse
        destination.chosenDistance = chosenDistance
        destination.houseManager = houseManager
    }
    
}

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenHouse = favoriteHouses[indexPath.row]
        guard chosenHouse != nil else { return }
        chosenDistance = locationManager.calculateDistance(latitude: chosenHouse!.latitude, longitude: chosenHouse!.longitude)
        performSegue(withIdentifier: "favoritesToDetail", sender: self)
    }
    
}

extension FavoriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteHouses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.createCustomHouseCell(for: tableView, houses: favoriteHouses, locationManager: locationManager, row: indexPath.row)
    }
    
}

