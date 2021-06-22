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
    var service: Service? {
        didSet{
            self.imageService.backgroundColor = .lightGray
            self.labelServiceName.text = service?.name
            self.labelServicePrice.text = "Price: Rp." + service!.price
            self.labelServiceCaption.text = service?.caption
            
            
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
