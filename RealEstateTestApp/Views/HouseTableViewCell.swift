//
//  HouseTableViewCell.swift
//  RealEstateTestApp
//
//  Created by Patrick Rugebregt on 22/02/2022.
//

import UIKit

class HouseTableViewCell: UITableViewCell {
    
    var imageData: Data? {
        didSet {
            DispatchQueue.main.async {
                self.houseImage.image = UIImage(data: self.imageData!)
            }
        }
    }
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numberOfBedroomLabel: UILabel!
    @IBOutlet weak var numberOfBathroomLabel: UILabel!
    @IBOutlet weak var squareMetersLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.frame.size.height = 100
        houseImage.layer.masksToBounds = true
        houseImage.layer.cornerRadius = 10
        houseImage.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView?.backgroundColor = .clear
        backgroundView?.alpha = 0
        contentView.backgroundColor = .clear
        self.layoutIfNeeded()
    }
    
}
