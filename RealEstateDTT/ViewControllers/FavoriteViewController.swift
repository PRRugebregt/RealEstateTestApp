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
    private var favoritesViewModel = FavoritesViewModel()
    /// Property dependency Injection by RootViewcontroller
    var locationManager: LocationManageable!
    var favoriteHouses : [House] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.favoriteHouses = self.favoritesViewModel.houses
            self.favoritesTableView.reloadData()
        }
    }
    
    // New method instead of prepareForSegue to have custom init in DetailViewController
    func showDetailViewController(for house: House, with distance: Float) {
        guard let viewController = storyboard?.instantiateViewController(
            identifier: "DetailViewController",
            creator: { coder in
                DetailViewController(chosenHouse: house, chosenDistance: distance, coder: coder)
            }
        ) else {
            fatalError("Failed to create Product Details VC")
        }
        print("check")
        show(viewController, sender: self)
    }
    
}

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenHouse = favoriteHouses[indexPath.row]
        if let chosenHouse = chosenHouse {
            chosenDistance = locationManager.calculateDistance(latitude: chosenHouse.latitude, longitude: chosenHouse.longitude)
            showDetailViewController(for: chosenHouse, with: chosenDistance)
        }
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

