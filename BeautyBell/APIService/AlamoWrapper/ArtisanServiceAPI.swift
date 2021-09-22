//
//  ArtisanServiceAPI.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi Azzami on 06/09/21.
//

import Foundation
import RxSwift
import RxCocoa

class ArtisanServiceAPI: AlamoWrapper {
    let failedProperty = PublishSubject<[DataError]>()
    public let failed: Driver<[DataError]>

    override init() {
        failed = failedProperty.asDriver(onErrorDriveWith: .empty())

        super.init()

    }
    func showServiceRating(id: String) -> Observable<Responses>{
        
        return request(endPoint: "-artisanReview", method: .get, parameter: ["id": id], failedProperty: failedProperty)
    }
}
