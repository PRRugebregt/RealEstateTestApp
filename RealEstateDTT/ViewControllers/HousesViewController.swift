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
    private var houses = [House]()
    private var locationManager = LocationManager()
    private var chosenHouse: House?
    private var chosenDistance: Float = 0
    var network: NetworkFetchable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        housesTableView.delegate = self
        housesTableView.dataSource = self
        housesTableView.register(UINib(nibName: "HouseTableViewCell", bundle: nil), forCellReuseIdentifier: "houseTableViewCell")
        housesTableView.dequeueReusableCell(withIdentifier: "houseTableViewCell")
        housesTableView.rowHeight = 103
        locationManager.fetchCurrentLocation()
        checkForCoreDataObjects()
    }
    
    func checkForCoreDataObjects() {
        let fetchedObjects = CoreDataManager.shared.fetchHouses()
        guard !fetchedObjects.isEmpty else {
            print("Coredata empty")
            downloadHouses()
            return
        }
        houses = fetchedObjects
        refreshTable()
    }
    
    func downloadHouses() {
        network.fetchFromApi { items in
            self.houses = items
            self.downloadImages()
        }
        CoreDataManager.shared.saveHouses(houses)
    }
    
    func downloadImages() {
        var count = 0
        for i in houses.indices {
            network.fetchImage(imagePath: houses[i].imageURL) { imageData in
                count += 1
                self.houses[i].imageData = imageData
                // not very elegant but making sure reloadData() only gets called once every image is loaded
                if count == self.houses.count {
                    self.refreshTable()
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
        let priceInDollars = Float(houseForCell.price) / 1000
        let priceAsString = String(format: "$ %.3f",priceInDollars)
        cell.priceLabel.text = priceAsString
        cell.addressLabel.text = houseForCell.zip + " " + houseForCell.city
        cell.numberOfBathroomLabel.text = String(houseForCell.bathrooms)
        cell.numberOfBedroomLabel.text = String(houseForCell.bedrooms)
        cell.distanceLabel.text = String(distanceToUser)
        cell.squareMetersLabel.text = String(houseForCell.size)
        return cell
    }
    
}

