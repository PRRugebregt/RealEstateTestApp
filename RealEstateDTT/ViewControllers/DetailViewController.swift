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
    private var detailViewModel: DetailViewModel
    var delegate: CanUpdateFavorites?
    var chosenDistance: Float = 0
    
    init?(chosenHouse: House, chosenDistance: Float, coder: NSCoder) {
        self.detailViewModel = DetailViewModel(chosenHouse: chosenHouse)
        self.chosenDistance = chosenDistance
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .clear
        descriptionLabel.adjustsFontSizeToFitWidth = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(popDetailView))
        navigationItem.leftBarButtonItem?.tintColor = .white
        setupUI()
        setupMap()
        mapView.delegate = self
    }
    
    // Making sure to display all the information of chosenHouse
    func setupUI() {
        let chosenHouse = detailViewModel.chosenHouse
            view.backgroundColor = .dttLightGray
        let pricePerM2 = PriceFormatter.shared.formatPrice(chosenHouse.price / chosenHouse.size) ?? "0"
            let priceAsString = PriceFormatter.shared.formatPrice(chosenHouse.price) ?? "0"
            if let imageData = chosenHouse.imageData {
                let image = UIImage(data: imageData)
                houseImage.image = image
            let buttonImage = chosenHouse.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            favoriteButton.setImage(buttonImage, for: .normal)
            priceLabel.text = "$\(priceAsString)"
            priceM2Label.text = "$\(pricePerM2) per m2"
            descriptionLabel.text = chosenHouse.descriptionString
            bedroomLabel.text = String(chosenHouse.bedrooms)
            bathroomLabel.text = String(chosenHouse.bathrooms)
            squareMetersLabel.text = String(chosenHouse.size)
            let distance = chosenDistance / 1000
            distanceLabel.text = String(format: "%.2f", distance)
            navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(popDetailView))
        }
    }
    
    // Zooming on the house Location
    func setupMap() {
        let center = detailViewModel.center
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapView.centerCoordinate = center
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 1500), animated: false)
        mapView.addAnnotation(detailViewModel.houseAnnotation)
    }
    
    // Method to pop viewcontroller when custom back button is pressed
    @objc func popDetailView() {
        navigationController?.popViewController(animated: true)
        navigationController?.navigationBar.isHidden = true
    }
    
    // Saving chosenHouse in favorite list by toggling isFavorite property.
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        self.detailViewModel.chosenHouse.isFavorite.toggle()
        detailViewModel.updateHouse()
        let imageName = detailViewModel.chosenHouse.isFavorite ? "heart.fill" : "heart"
        print(imageName)
        delegate?.updateFavorites()
        DispatchQueue.main.async {
            self.favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
}

extension DetailViewController: MKMapViewDelegate {
    
    // Creating mapView with address as title.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? HouseAnnotation else { return nil }
        let identifier = Constants.houseIdentifier
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
        detailViewModel.openLocationInMaps(from: view)
    }
}
