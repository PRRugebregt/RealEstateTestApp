//
//  ViewController.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 22/02/2022.
//

import UIKit

class HousesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var housesTableView: UITableView!
    @IBOutlet weak var noSearchResultsImage: UIImageView!
    private let houseManager = HouseManager(network: NetworkDownload())
    private let filter = Filter()
    private var chosenHouse: House?
    private var chosenDistance: Float = 0
    private var houses = [House]() {
        didSet {
            houses.sort(by: {$0.price < $1.price})
            refreshTable()
        }
    }
    private var locationManager: LocationManager {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.locationManager
        }
        set {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateHouses(_:)), name: .updateHouses, object: nil)
        let favoriteController = self.tabBarController?.viewControllers?[2] as! FavoriteViewController
        favoriteController.houseManager = houseManager
        setupUI()
        
        locationManager.houseViewController = self
        searchBar.delegate = self
        
        housesTableView.delegate = self
        housesTableView.dataSource = self
        housesTableView.register(UINib(nibName: "HouseTableViewCell", bundle: nil), forCellReuseIdentifier: "houseTableViewCell")
        housesTableView.dequeueReusableCell(withIdentifier: "houseTableViewCell")
        housesTableView.rowHeight = 140
        
        if locationManager.locationManager.authorizationStatus == .denied || locationManager.locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.fetchCurrentLocation()
            loadData()
        } else {
            askForLocationUse()
        }
    }
    
    func loadData() {
        houseManager.checkForCoreDataObjects()
    }
    
    func setupUI() {
        housesTableView.backgroundColor = .clear
        housesTableView.separatorStyle = .none
        tabBarController?.tabBar.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
    }
    
    func askForLocationUse() {
        locationManager.locationManager.requestWhenInUseAuthorization()
        locationManager.fetchCurrentLocation()
    }
    
    // Responding to notification posted by HouseManager
    @objc func updateHouses(_ notification: Notification) {
        print("received notification in housesviewcontroller")
        if let houses = notification.userInfo?["houses"] as? [House] {
            self.houses = houses
        }
    }
    
    func refreshTable() {
        DispatchQueue.main.async {
            self.locationManager.fetchCurrentLocation()
            self.housesTableView.reloadData()
        }
    }
    
    // Preparing for segue to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailViewController
        destination.chosenHouse = chosenHouse
        destination.chosenDistance = chosenDistance
        destination.houseManager = houseManager
    }
    
}

extension HousesViewController: UITableViewDelegate {
    
    // Saving selected house to property chosenHouse to be used in segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenHouse = houses[indexPath.row]
        guard chosenHouse != nil else { return }
        chosenDistance = locationManager.calculateDistance(latitude: chosenHouse!.latitude, longitude: chosenHouse!.longitude)
        performSegue(withIdentifier: "housesToDetail", sender: self)
    }
    
}

extension HousesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.createCustomHouseCell(for: tableView, houses: houses, locationManager: locationManager, row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
}

extension HousesViewController: UISearchBarDelegate {
    
    // Reset search results
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.houses = filter.filter(with: "")
        refreshTable()
    }
    
    // Filter results with text from searchbar. Hide or unhide noResultsImage based on results.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        houses = filter.filter(with: searchText)
        noSearchResultsImage.alpha = houses.isEmpty ? 1 : 0
        refreshTable()
    }
}

