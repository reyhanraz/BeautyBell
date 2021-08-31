//
//  Artisan.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 21/06/21.
//

import Foundation
import GRDB

public class Artisan: Codable, FetchableRecord, PersistableRecord {
    let id, createdAt, name: String
    let avatar: String
    let image, user_image: String
    let rating, description: String
    let services: [Service]?
    
    init(id: String, createdAt: String, name: String, avatar: String, image: String, user_image: String, rating: String, description: String, services: [Service]? = nil) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.avatar = avatar
        self.image = image
        self.user_image = user_image
        self.rating = rating
        self.description = description
        self.services = services
    }

    enum CodingKeys: String, CodingKey {
        case id, createdAt, name, avatar, image
        case user_image
        case rating
        case description
        case services
    }
    
    public enum ColumnName: String, ColumnExpression{
        case id
        case createdAt
        case name
        case avatar
        case image
        case user_image
        case rating
        case description
    }
    
    public func insert(_ db: Database) throws {
        let sql = """
            INSERT INTO \(TableNames.Artisan.artisan)
            (
            \(ColumnName.id),
            \(ColumnName.createdAt),
            \(ColumnName.name),
            \(ColumnName.avatar),
            \(ColumnName.image),
            \(ColumnName.user_image),
            \(ColumnName.rating),
            \(ColumnName.description)

            ) VALUES (?,?,?,?,?,?,?,?)
            
            """
        let arguments : StatementArguments = [id, createdAt, name, avatar, image, user_image, rating, description]
        try db.execute(sql: sql, arguments: arguments)
        
        try services?.forEach{ service in
            let sql = """
                INSERT INTO \(TableNames.Artisan.service)
                (
                \(Service.ColumnName.artisanID)
                \(Service.ColumnName.name),
                \(Service.ColumnName.price),
                \(Service.ColumnName.caption)
                ) VALUES (?,?,?,?)
                """
            let arguments: StatementArguments = [id, service.name, service.price, service.caption]
            try db.execute(sql: sql, arguments: arguments)
        }
    }
    
    static func fetchAll(_ db: Database) throws -> [Artisan]{
        let row = try Row.fetchAll(db, sql:
        """
            SELECT * FROM \(TableNames.Artisan.artisan)
        """)
        return try row.map{row in
            let keyID = row[ColumnName.id]
            
            let service = try Service.fetchAll(db, key: keyID as! String)
            
            return Artisan(id: keyID as! String,
                           createdAt: row[ColumnName.createdAt],
                           name: row[ColumnName.name],
                           avatar: row[ColumnName.avatar],
                           image: row[ColumnName.image],
                           user_image: row[ColumnName.user_image],
                           rating: row[ColumnName.rating],
                           description: row[ColumnName.description],
                           services: service)

        }
        
    }
}
