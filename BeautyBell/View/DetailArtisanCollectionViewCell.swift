//
//  DetailArtisanCollectionViewCell.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 21/06/21.
//

import UIKit

class DetailArtisanCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var labelServiceName: UILabel!
    @IBOutlet weak var labelServicePrice: UILabel!
    @IBOutlet weak var labelServiceCaption: UILabel!
    var urlImage: String?
    var service: ServiceViewModel? {
        didSet{
            self.imageService.backgroundColor = .lightGray
            self.labelServiceName.text = service?.serviceName
            self.labelServicePrice.text = "Price: Rp." + service!.servicePrice
            self.labelServiceCaption.text = service?.serviceCaption
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 10
    }

}
