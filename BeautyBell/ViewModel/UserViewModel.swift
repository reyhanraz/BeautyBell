//
//  UserViewModel.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 09/07/21.
//

import Foundation
import UIKit
import AlamofireImage

struct UserViewModel{
    var userName: String
    var userDOB: String
    var userImageURL: String
    var userEmail: String
    
    init(user: Users) {
        self.userName = user.name
        self.userDOB = user.dateOfBirth
        self.userEmail = user.email
        self.userImageURL = user.imageURL
    }
    
    func loadImage(completion: @escaping(UIImage?) -> Void) {
        let urlString = userImageURL
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard let data = data else { return }
                let image = UIImage(data: data)
                completion(image)
            }.resume()
        }
}
