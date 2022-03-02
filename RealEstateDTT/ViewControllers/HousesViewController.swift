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
    /// property dependency injection by rootviewcontroller
    var locationManager: LocationManageable?
    var houseManager: HouseManager?
    private var chosenHouse: House?
    private var chosenDistance: Float = 0
    private var houses = [House]() {
        didSet {
            refreshTable()
            DispatchQueue.main.async {
                self.noSearchResultsImage.alpha = self.houses.isEmpty ? 1 : 0
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(updateHouses(_:)), name: .updateHouses, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: .refreshData, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        searchBar.delegate = self
        housesTableView.delegate = self
        housesTableView.dataSource = self
        housesTableView.register(UINib(nibName: "HouseTableViewCell", bundle: nil), forCellReuseIdentifier: "houseTableViewCell")
        housesTableView.dequeueReusableCell(withIdentifier: "houseTableViewCell")
        housesTableView.rowHeight = 140
    }
    
    func setupUI() {
        housesTableView.backgroundColor = .clear
        housesTableView.separatorStyle = .none
        tabBarController?.tabBar.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
    }
    
    // Responding to notification posted by HouseManager
    @objc func updateHouses(_ notification: Notification) {
        print("received notification in housesviewcontroller")
        if let houses = notification.userInfo?["houses"] as? [House] {
            self.houses = houses
        }
    }
    
    // Reloading table when locationManager auth changes, or houses change.
    @objc func refreshTable() {
        DispatchQueue.main.async {
            self.housesTableView.reloadData()
        }
    }
    
    // Preparing for segue to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController, let chosenHouse = houseManager?.chosenHouse {
            print(chosenHouse)
            destination.chosenHouse = chosenHouse
            destination.chosenDistance = houseManager?.chosenDistance ?? 0
        }
    }
    
}

extension HousesViewController: UITableViewDelegate {
    
    // Saving selected house to property chosenHouse to be used in segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        houseManager?.chooseHouse(houses[indexPath.row])
        guard houseManager?.chosenHouse != nil else { return }
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
        houseManager?.filter(with: "")
        refreshTable()
    }
    
    // Filter results with text from searchbar. Hide or unhide noResultsImage based on results.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        houseManager?.filter(with: searchText)
        refreshTable()
    }
    
    // Dismiss keyboard after return
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

