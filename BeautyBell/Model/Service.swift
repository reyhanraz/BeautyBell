//
//  Service.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 22/06/21.
//

import Foundation
import GRDB

// MARK: - Service
public class Service: Codable, FetchableRecord, PersistableRecord{
    let name: String
    let price: String
    let caption: String
    
    init(name: String, price: String, caption: String) {
        self.name = name
        self.price = price
        self.caption = caption
    }
    
    public enum ColumnName: String, ColumnExpression{
        case id
        case artisanID
        case price
        case name
        case caption
    }
    
    static func fetchAll(_ db: Database, key: String) throws -> [Service]{
        let serviceRow = try Row.fetchAll(db, sql: """
            SELECT * FROM \(TableNames.Artisan.service) WHERE \(Service.ColumnName.artisanID) = ?
        """, arguments: [key])
        
        let service = serviceRow.map{ service in
            return Service(name: service[Service.ColumnName.name],
                           price: service[Service.ColumnName.price],
                           caption: service[Service.ColumnName.caption])
        }
        return service
    }
}

