//
//  ArtisanCloudService.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi Azzami on 01/09/21.
//

import Foundation
import Moya
import RxSwift

public struct ArtisanCloudService: serviceType{
    let _service = MoyaProvider<ArtisanAPI>()

    
    func getAll() throws -> Observable<[Artisan]> {
        let response: Single<Response>
        response = _service.rx.request(.getAll)
        return response
            .retry(3).map({
                let artisan = try JSONDecoder().decode([Artisan].self, from: $0.data)
                let delegate = UIApplication.shared.delegate as! AppDelegateType
                ArtisanSQLCache(dbQueue: delegate.dbQueue, tableName: TableNames.Artisan.artisan).putList(models: artisan)

                return artisan
            }).asObservable()
    }
    
    func getServiceByArtisanID(id: String) throws -> Observable<[Service]> {
        let response: Single<Response>
        response = _service.rx.request(.getDetail(id: id))
        return response
            .retry(3).map({
                let artisan = try JSONDecoder().decode(Artisan.self, from: $0.data)
                guard let _service = artisan.services else {
                    return []
                }
                return _service
            }).asObservable()
    }
}
