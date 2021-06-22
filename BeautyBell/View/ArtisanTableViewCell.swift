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
    var imageURL: String?
    
    var artisan: Artisan?{
        didSet{
            labelArtisanName.text = artisan?.name
            labelDescription.text = artisan?.description
            guard let imageURL = artisan?.avatar else {return}
            DispatchQueue.main.async {
                self.imageArtisan.af.setImage(withURL: URL(string: imageURL)!,placeholderImage: UIImage(named: "PlaceHolder"))
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
