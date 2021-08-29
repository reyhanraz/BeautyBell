//
//  ArtisanTableViewCell.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 21/06/21.
//

import UIKit
import AlamofireImage
import Alamofire

class ArtisanTableViewCell: UITableViewCell {

    @IBOutlet weak var imageArtisan: UIImageView!
    @IBOutlet weak var labelArtisanName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    var artisanViewModel: ArtisanViewModel? {
        didSet{
            self.labelArtisanName.text = artisanViewModel?.artisanName
            self.labelDescription.text = artisanViewModel?.artisanDescString
            artisanViewModel?.loadImage(completion: { image in
                DispatchQueue.main.async {
                    self.imageArtisan.image = image
                }
            })
        }
    }
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelArtisanName.isSkeletonable = true
        labelDescription.isSkeletonable = true
        imageArtisan.isSkeletonable = true
        isSkeletonable = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
