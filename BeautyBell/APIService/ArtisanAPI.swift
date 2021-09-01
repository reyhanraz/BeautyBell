//
//  Service.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 21/06/21.
//

import Foundation
import Alamofire
import Moya

enum ArtisanAPI {
    case getAll
    case getDetail(id: String)
}

extension ArtisanAPI: TargetType{
    var baseURL: URL {
        return URL(string: "https://604048b4f34cf600173c7cda.mockapi.io/api/v1")!
    }
    
    var path: String {
        switch self {
        case .getAll:
            return "/list-artisan"
        case .getDetail(id: let id):
            return "/list-artisan/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
