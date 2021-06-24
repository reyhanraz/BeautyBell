//
//  ArtisanViewModel.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 23/06/21.
//

import Foundation
import UIKit
import AlamofireImage
struct ArtisanViewModel{
    let artisanName: String
    let artisanDescString: String
    let artisanPhotoURL: String
    let artisanID: String
    
    init(Artisan: Artisan) {
        self.artisanName = Artisan.name
        self.artisanDescString = Artisan.description
        self.artisanPhotoURL = Artisan.avatar
        self.artisanID = Artisan.id
        
    }
    
    func loadImage(completion: @escaping(UIImage?) -> Void) {
        let urlString = artisanPhotoURL
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard let data = data else { return }
                let image = UIImage(data: data)
                completion(image)
            }.resume()
        }
}
