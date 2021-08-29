//
//  Artisan.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 21/06/21.
//

import Foundation
import GRDB

struct Artisan: Codable {
    let id, createdAt, name: String
    let avatar: String
    let image, userImage: String
    let rating, description: String
    let services: [Service]

    enum CodingKeys: String, CodingKey {
        case id, createdAt, name, avatar, image
        case userImage = "user_image"
        case rating
        case description = "description"
        case services
    }
    
    public enum ColumnName: String, ColumnExpression{
        case id
        case createdAt
        case name
        case avatar
        case image
        case userImage
        case rating
        case description
    }
}
