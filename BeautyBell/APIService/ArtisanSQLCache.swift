//
//  ArtisanSQLCache.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 29/08/21.
//

import GRDB
import RxSwift

struct ArtisanSQLCache{
    
    
    private let _dbQueue: DatabaseQueue
    private let _tableName: String
    private let _expiredAfter: TimeInterval
    
    init(dbQueue: DatabaseQueue, tableName: String, expiredAfter: TimeInterval = 86400) {
        _dbQueue = dbQueue
        _tableName = tableName
        _expiredAfter = expiredAfter
    }
    
    public static func createTable(db: Database, tableName: String) throws{
        try db.create(table: tableName, body: { body in
            body.column(Artisan.ColumnName.id.rawValue, .text).primaryKey(onConflict: .replace, autoincrement: false)
            body.column(Artisan.ColumnName.createdAt.rawValue, .text).notNull()
            body.column(Artisan.ColumnName.name.rawValue, .text).notNull()
            body.column(Artisan.ColumnName.avatar.rawValue, .text).notNull()
            body.column(Artisan.ColumnName.image.rawValue, .text).notNull()
            body.column(Artisan.ColumnName.user_image.rawValue, .text).notNull()
            body.column(Artisan.ColumnName.rating.rawValue, .text).notNull()
            body.column(Artisan.ColumnName.description.rawValue, .text).notNull()
        })
    }
    func getAll() throws -> [Artisan] {
        try _dbQueue.read{db -> [Artisan] in
            let artisan = try Artisan.fetchAll(db)
            return artisan
        }
    }
    
    func getServiceByArtisanID(id: String) throws -> [Service] {
        return try _dbQueue.read{db in
            let service = try Service.fetchAll(db, key: id)
            return service
        }
    }
    
    public func putList(models: [Artisan]) {
        do {
            try _dbQueue.inTransaction { db in
                
                for item in models {
                    
                    try item.insert(db)
                }
                
                return .commit
            }
        } catch {
            assertionFailure()
        }
    }
}

struct ServiceSQLCache {
    private let _dbQueue: DatabaseQueue
    private let _tableName: String
    private let _expiredAfter: TimeInterval
    
    init(dbQueue: DatabaseQueue, tableName: String, expiredAfter: TimeInterval = 86400) {
        _dbQueue = dbQueue
        _tableName = tableName
        _expiredAfter = expiredAfter
    }
    
    public static func createTable(db: Database, tableName: String) throws{
        try db.create(table: tableName, body: { body in
            body.column(Service.ColumnName.artisanID.rawValue, .text).references(TableNames.Artisan.artisan, column: Artisan.ColumnName.id.rawValue, onDelete: .cascade, onUpdate: .cascade).notNull()
            body.column(Service.ColumnName.price.rawValue, .text).notNull()
            body.column(Service.ColumnName.name.rawValue, .text).notNull()
            body.column(Service.ColumnName.caption.rawValue, .text).notNull()
        })
    }
    
    func getAll(id: String) throws -> [Service] {
        try _dbQueue.read{db -> [Service] in
            let service = try Service.fetchAll(db, key: id)
            return service
        }
    }
    
}


