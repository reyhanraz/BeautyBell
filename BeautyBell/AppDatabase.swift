//
//  AppDatabase.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 29/08/21.
//

import GRDB

struct AppDatabase{
    
    static func openDatabase(atPath path: String) throws -> DatabaseQueue {
        var config = Configuration()
        
        let dbQueue = try DatabaseQueue(path: path, configuration: config)
        
        try migrator.migrate(dbQueue)
        
        print("table Created")
        return dbQueue
    }
    
    static func checkColumn(queue: DatabaseQueue, tableName: String) throws {
        try queue.read{ db in
            let column = try db.columns(in: tableName)
            print(column)
        }
    }
    
    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("v1") { db in
            try ArtisanSQLCache.createTable(db: db, tableName: TableNames.Artisan.artisan)
            try ServiceSQLCache.createTable(db: db, tableName: TableNames.Artisan.service)
        }
        return migrator
    }
}

struct TableNames {
    struct Artisan {
        public static let artisan = "Artisan"
        public static let service = "Service"

    }
}
