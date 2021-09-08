//
//  ListViewModel.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 27/08/21.
//

import Moya
import RxSwift
import RxCocoa

protocol serviceType{
    func getAll() throws -> Observable<[Artisan]>
    func getServiceByArtisanID(id: String) throws -> Observable<[Service]>
}

struct ListViewModel{
    private let _array = BehaviorRelay<[ArtisanViewModel]>(value: [])
    var _output : Driver<[ArtisanViewModel]>{
        return _array.asDriver()
    }
    private let _arrayService = BehaviorRelay<[ServiceViewModel]>(value: [])
    var _outputService : Driver<[ServiceViewModel]>{
        return _arrayService.asDriver()
    }
    
    let cacheService: serviceType
    let apiService: serviceType
    let loadFromCache: Bool
    init(cacheService: serviceType, apiService: serviceType, loadFromCache: Bool = false) {
        self.cacheService = cacheService
        self.apiService = apiService
        self.loadFromCache = loadFromCache
    }
    
    func getAll() -> Driver<[ArtisanViewModel]>{
        var _service: serviceType
        if !loadFromCache{
            _service = apiService
            print("From Service")
        }else{
            _service = cacheService
            print("From Cache")
        }
        
        do {
            let artisan = try _service.getAll()
            print(artisan)
            return artisan.map{
                $0.map{
                    ArtisanViewModel(Artisan: $0)
                }
            }.asDriver(onErrorDriveWith: .empty())
        } catch let error {
            print(error.localizedDescription)
        }
        return _output
    }
    
    func getServicebyArtisanID(id: String) -> Driver<[ServiceViewModel]>{
        var _service: serviceType
        if !loadFromCache{
            _service = apiService
        }else{
            _service = cacheService
        }
        do {
            let service = try _service.getServiceByArtisanID(id: id)
            print(service)
            return service.map({
                $0.map{
                    ServiceViewModel(service: $0)
                }
            }).asDriver(onErrorDriveWith: .empty())
        } catch let error {
            print(error.localizedDescription)
        }
        return _outputService
    }
}
