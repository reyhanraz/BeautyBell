//
//  DetailArtisanHeader.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 09/07/21.
//

import UIKit

class DetailArtisanHeader: UIView {
    
 
    @IBOutlet weak var artisanName: UILabel!
    @IBOutlet weak var artisanDesc: UILabel!
    @IBOutlet weak var artisanImage: UIImageView!
    @IBOutlet weak var artisanRate: UIStackView!
    var artisan : ArtisanViewModel? {
        didSet{
            self.artisanDesc.text = artisan?.artisanDescString
            self.artisanName.text = artisan?.artisanName
            artisan?.loadImage(completion: { image in
                DispatchQueue.main.async {
                    self.artisanImage.image = image
                }
            })
            loadStars(arrStars: artisan?.loadRating() ?? [false])

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed("DetailArtisanHeader", owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
    
    func loadStars(arrStars: [Bool]){
        for index in arrStars{
            var startsImage = UIImageView()
            if index{
                startsImage = UIImageView(image: UIImage(systemName: "star.fill"))
            }else{
                startsImage = UIImageView(image: UIImage(systemName: "star"))
            }
            startsImage.layer.borderColor = UIColor.black.cgColor
            startsImage.tintColor = UIColor.systemYellow
            artisanRate.addArrangedSubview(startsImage)
        }
    }
}
