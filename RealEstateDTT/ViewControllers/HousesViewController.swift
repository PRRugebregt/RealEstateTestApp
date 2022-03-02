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
    var houseManager: HouseManager!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: .refreshData, object: nil)
        self.houseManager = HouseManager()
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
    
    // Reloading table when locationManager auth changes, or houses change.
    @objc func refreshTable() {
        DispatchQueue.main.async {
            self.housesTableView.reloadData()
            self.noSearchResultsImage.alpha = self.houseManager.houses.isEmpty ? 1 : 0
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
            fatalError("Failed to create Detail ViewController")
        }
        viewController.delegate = houseManager
        show(viewController, sender: self)
    }
    
}

extension HousesViewController: UITableViewDelegate {
    
    // Saving selected house to property chosenHouse to be used in segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        houseManager.chooseHouse(with: indexPath.row)
        if let chosenHouse = houseManager.chosenHouse {
            let distance = houseManager.chosenDistance
            showDetailViewController(for: chosenHouse, with: distance)
        }
    }
    
}

extension HousesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseManager.houses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.createCustomHouseCell(for: tableView, houses: houseManager.houses, locationManager: houseManager.locationManager, row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
}

extension HousesViewController: UISearchBarDelegate {
    
    // Reset search results
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        houseManager.filter(with: "")
        refreshTable()
    }
    
    // Filter results with text from searchbar. Hide or unhide noResultsImage based on results.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        houseManager.filter(with: searchText)
        refreshTable()
    }
    
    // Dismiss keyboard after return
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

