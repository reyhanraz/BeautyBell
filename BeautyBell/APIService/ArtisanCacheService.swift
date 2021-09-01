//
//  ArtisanCacheService.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi Azzami on 01/09/21.
//

import RxSwift

public struct ArtisanCacheService: serviceType{
    
    let _ArtisanSQLCache: ArtisanSQLCache
    
    init (cache: ArtisanSQLCache){
        _ArtisanSQLCache = cache
    }
    
    func getAll() throws -> Observable<[Artisan]> {
        let artisan = try _ArtisanSQLCache.getAll()
        return Observable.just(artisan)
    }
    
    func getServiceByArtisanID(id: String) throws -> Observable<[Service]> {
        
        Observable<[Service]>.empty()
    }
}

public struct ArtisanServiceCacheService: serviceType{
    
    let _ServiceSQLCache: ServiceSQLCache
    
    init (cache: ServiceSQLCache){
        _ServiceSQLCache = cache
    }
    
    func getAll() throws -> Observable<[Artisan]> {
        
        return Observable<[Artisan]>.empty()
    }
    
    func getServiceByArtisanID(id: String) throws -> Observable<[Service]> {
        let service = try _ServiceSQLCache.getAll(id: id)
        return Observable.just(service)
    }
}
