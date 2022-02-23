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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bedroomLabel: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var squareMetersLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var chosenHouse: House!
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
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(popDetailView))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        setupUI()
        setupMap()
        mapView.delegate = self

    }
    
    func setupUI() {
        self.view.backgroundColor = .dttLightGray
        if let imageData = chosenHouse.imageData {
            let image = UIImage(data: imageData)
            houseImage.image = image
        }
        let priceInDollars = Float(chosenHouse.price) / 1000
        let priceAsString = String(format: "$ %.3f",priceInDollars)
        priceLabel.text = priceAsString
        descriptionLabel.text = chosenHouse.descriptionString
        bedroomLabel.text = String(chosenHouse.bedrooms)
        bathroomLabel.text = String(chosenHouse.bathrooms)
        squareMetersLabel.text = String(chosenHouse.size)
        distanceLabel.text = String(chosenDistance / 1000)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(popDetailView))
    }
    
    func setupMap() {
        let center = CLLocationCoordinate2D(latitude: Double(chosenHouse.latitude), longitude: Double(chosenHouse.longitude))
        mapView.centerCoordinate = center
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 1000), animated: true)
        mapView.addAnnotation(houseAnnotation)
    }

    @objc func popDetailView() {
        print("called")
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
}

extension DetailViewController: MKMapViewDelegate {
    
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
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let houseAnnotation = view.annotation as? HouseAnnotation else { return }
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        houseAnnotation.mapItem?.openInMaps(launchOptions: launchOptions)
    }
}
