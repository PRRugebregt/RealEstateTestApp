//
//  HouseTableViewCell.swift
//  RealEstateDTT
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
