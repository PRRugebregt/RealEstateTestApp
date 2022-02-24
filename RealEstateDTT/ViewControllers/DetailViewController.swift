//
//  DetailViewController.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 22/02/2022.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceM2Label: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bedroomLabel: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var squareMetersLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var chosenHouse: House!
    var houseManager: HouseManager!
    var houseAnnotation: HouseAnnotation {
        let zip = chosenHouse.zip
        let city = chosenHouse.city
        let coordinate = CLLocationCoordinate2D(latitude: chosenHouse.latitude,
                                                longitude: chosenHouse.longitude)
        return HouseAnnotation(title: "\(city), \(zip)",
                               coordinate: coordinate,
                               zip: zip,
                               city: city)
    }
    var chosenDistance: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(chosenHouse.isFavorite)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .clear
        descriptionLabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(popDetailView))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        setupUI()
        setupMap()
        mapView.delegate = self
        
    }
    
    // Making sure to display all the information of chosenHouse
    func setupUI() {
        self.view.backgroundColor = .dttLightGray
        if let imageData = chosenHouse.imageData {
            let image = UIImage(data: imageData)
            houseImage.image = image
        }
        let buttonImage = chosenHouse.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        favoriteButton.setImage(buttonImage, for: .normal)
        let priceAsString = PriceFormatter.shared.formatPrice(chosenHouse.price)
        priceLabel.text = "$\(priceAsString!)"
        let pricePerM2 = chosenHouse.price / chosenHouse.size
        priceM2Label.text = "$\(PriceFormatter.shared.formatPrice(pricePerM2)!) per m2"
        descriptionLabel.text = chosenHouse.descriptionString
        bedroomLabel.text = String(chosenHouse.bedrooms)
        bathroomLabel.text = String(chosenHouse.bathrooms)
        squareMetersLabel.text = String(chosenHouse.size)
        let distance = chosenDistance / 1000
        distanceLabel.text = String(format: "%.2f", distance)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(popDetailView))
    }
    
    // Zooming on the house Location
    func setupMap() {
        let center = CLLocationCoordinate2D(latitude: Double(chosenHouse.latitude), longitude: Double(chosenHouse.longitude))
        mapView.centerCoordinate = center
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 1000), animated: true)
        mapView.addAnnotation(houseAnnotation)
    }
    
    // Method to pop viewcontroller when custom back button is pressed
    @objc func popDetailView() {
        print("called")
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // Saving chosenHouse in favorite list by toggling isFavorite property.
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        chosenHouse.isFavorite.toggle()
        houseManager.updateHouse(chosenHouse, isFavorite: chosenHouse.isFavorite)
        if chosenHouse.isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    
}

extension DetailViewController: MKMapViewDelegate {
    
    // Creating mapView with address as title.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? HouseAnnotation else { return nil }
        let identifier = "house"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let button = UIButton(type: .detailDisclosure)
            button.setImage(UIImage(named: "finish"), for: .normal)
            button.tintColor = .blue
            view.rightCalloutAccessoryView = button
        }
        return view
    }
    
    // AccessoryButton shows route to house
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let houseAnnotation = view.annotation as? HouseAnnotation else { return }
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        houseAnnotation.mapItem?.openInMaps(launchOptions: launchOptions)
    }
}
