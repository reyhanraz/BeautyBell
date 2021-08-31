//
//  ArtisanSQLCache.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 29/08/21.
//

import GRDB

struct ArtisanSQLCache {
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
            body.column(Artisan.ColumnName.id.rawValue, .text).primaryKey()
            body.column(Artisan.ColumnName.createdAt.rawValue, .text).notNull()
            body.column(Artisan.ColumnName.name.rawValue, .text).notNull()
            body.column(Artisan.ColumnName.avatar.rawValue, .text).notNull()
            body.column(Artisan.ColumnName.image.rawValue, .text).notNull()
            body.column(Artisan.ColumnName.user_image.rawValue, .text).notNull()
            body.column(Artisan.ColumnName.rating.rawValue, .text).notNull()
            body.column(Artisan.ColumnName.description.rawValue, .text).notNull()
        })
    }
    
    public static func getList(){
        
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
            body.column(Service.ColumnName.id.rawValue, .integer).primaryKey(onConflict: .replace, autoincrement: true)
            body.column(Service.ColumnName.artisanID.rawValue, .text).references(TableNames.Artisan.artisan, column: Artisan.ColumnName.id.rawValue, onDelete: .cascade, onUpdate: .cascade).notNull()
            body.column(Service.ColumnName.name.rawValue, .text).notNull()
            body.column(Service.ColumnName.caption.rawValue, .text).notNull()
        })
    }
    
    public static func getList(){
        
    }
}


