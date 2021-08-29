//
//  AppDatabase.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 29/08/21.
//

import GRDB

struct AppDatabase{
    
    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("v1") { db in
//            try ArtisanSQLCache.createTable(db: db, tableName: TableNames.Artisan.artisan)
        }
        return migrator
    }
}

struct TableNames {
    struct Artisan {
        public static let artisan = "Artisan"
    }
}
