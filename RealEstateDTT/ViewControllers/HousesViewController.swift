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
    private var filter = Filter()
    private var houses = [House]() {
        didSet {
            houses.sort(by: {$0.price < $1.price})
        }
    }
    private var locationManager = LocationManager()
    private var chosenHouse: House?
    private var chosenDistance: Float = 0
    var network: NetworkFetchable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .dttLightGray
        housesTableView.backgroundColor = .clear
        tabBarController?.tabBar.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        searchBar.delegate = self
        
        housesTableView.delegate = self
        housesTableView.dataSource = self
        housesTableView.register(UINib(nibName: "HouseTableViewCell", bundle: nil), forCellReuseIdentifier: "houseTableViewCell")
        housesTableView.dequeueReusableCell(withIdentifier: "houseTableViewCell")
        housesTableView.rowHeight = 103
        
        locationManager.locationManager.requestWhenInUseAuthorization()
        if locationManager.locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.fetchCurrentLocation()
        }
        
        checkForCoreDataObjects()
    }
    
    // When houses haven't been saved to CoreData yet, fetch them from network, else load them from coredata
    func checkForCoreDataObjects() {
        let fetchedObjects = CoreDataManager.shared.fetchHouses()
        guard !fetchedObjects.isEmpty else {
            downloadHouses()
            return
        }
        print("Loaded from coredata")
        houses = fetchedObjects
        filter.originalHousesList = houses
        refreshTable()
    }
    
    func downloadHouses() {
        network.fetchFromApi { items in
            self.houses = items
            self.downloadImages()
        }
    }
    
    /* not very elegant but making sure reloadData() only gets called once every image is loaded
    with count == self.houses.count
     */
    func downloadImages() {
        var count = 0
        for i in houses.indices {
            network.fetchImage(imagePath: houses[i].imageURL) { imageData in
                count += 1
                self.houses[i].imageData = imageData
                if count == self.houses.count {
                    self.refreshTable()
                    self.filter.originalHousesList = self.houses
                    CoreDataManager.shared.saveHouses(self.houses)
                }
            }
        }
    }
    
    func refreshTable() {
        DispatchQueue.main.async {
            self.housesTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailViewController
        destination.chosenHouse = chosenHouse
        destination.chosenDistance = chosenDistance
    }

}

extension HousesViewController: UITableViewDelegate {
    
    // Saving selected house to property chosenHouse to be used in segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenHouse = houses[indexPath.row]
        guard chosenHouse != nil else { return }
        chosenDistance = locationManager.calculateDistance(latitude: chosenHouse!.latitude, longitude: chosenHouse!.longitude)
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
}

extension HousesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "houseTableViewCell") as! HouseTableViewCell
        let houseForCell = houses[indexPath.row]
        let distanceToUser = locationManager.calculateDistance(latitude: houseForCell.latitude,
                                                               longitude: houseForCell.longitude)
        if let imageData = houseForCell.imageData {
            cell.houseImage.image = UIImage(data: imageData)
        } else {
            cell.houseImage.image = UIImage(named: "home-2")
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let priceString = numberFormatter.string(from: NSNumber(integerLiteral: houseForCell.price))
        cell.priceLabel.text = "$\(priceString!)" // Formatted as (1,000,000)
        cell.addressLabel.text = houseForCell.zip + " " + houseForCell.city
        cell.numberOfBathroomLabel.text = String(houseForCell.bathrooms)
        cell.numberOfBedroomLabel.text = String(houseForCell.bedrooms)
        cell.distanceLabel.text = String(distanceToUser)
        cell.squareMetersLabel.text = String(houseForCell.size)
        return cell
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

