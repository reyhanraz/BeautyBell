//
//  ArtisanServiceAPI.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi Azzami on 06/09/21.
//

import Foundation
import RxSwift
class ArtisanServiceAPI: AlamoWrapper {
    func showServiceRating(id: String) -> Observable<Responses>{
        
        return request(endPoint: "-artisanReview", method: .get, parameter: ["id": id])
    }
}
