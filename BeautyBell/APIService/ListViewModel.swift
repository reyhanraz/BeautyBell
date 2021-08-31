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
    func get()
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
    let _service = MoyaProvider<ArtisanAPI>()
    
    let cacheService: serviceType
    let apiService: serviceType
    let loadFromCache: Bool
    init(cacheService: serviceType, apiService: serviceType, loadFromCache: Bool = false) {
        self.cacheService = cacheService
        self.apiService = apiService
        self.loadFromCache = loadFromCache
    }
    
    func getListArtisan() -> Driver<[ArtisanViewModel]>{
        _service.request(.getAll) { result in
            switch result{
            case .success(let response):
                do{
                    let data = response.data
                    let artisans = try JSONDecoder().decode([Artisan].self, from: data)
                    _array.accept(artisans.map({ArtisanViewModel(Artisan: $0)}))
                }catch{
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return _output
    }
    
    func getArtisanByID(id: Int) -> Driver<[ServiceViewModel]>{
        _service.request(.getDetail(id: id)) { result in
            switch result{
            case .success(let response):
                do{
                    let data = response.data
                    let artisans = try JSONDecoder().decode(Artisan.self, from: data)
                    if let service = artisans.services{
                        _arrayService.accept(service.map({ServiceViewModel(service: $0)}))
                    }
                }catch let error{
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return _outputService
    }
}
