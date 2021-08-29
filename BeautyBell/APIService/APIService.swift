//
//  Service.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 21/06/21.
//

import Foundation
import Alamofire
import Moya

enum APIServices {
    case getAll
    case getDetail(id: Int)
    
//    static let baseURL = "https://604048b4f34cf600173c7cda.mockapi.io/api/v1/list-artisan"
//    typealias artisansCallback = (_ artisans:[Artisan]?, _ status: Bool, _ message: String) -> Void
//    var callBack: artisansCallback?
//    typealias servicesCallback = (_ services:[Service]?, _ status: Bool, _ message: String) -> Void
//    var servicescallBack: servicesCallback?
//
//
//    func getAllArtisan(){
//        AF.request(APIServices.baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { responseData in
//            guard let data = responseData.data else {
//                self.callBack?(nil, false, "")
//                return}
//            do{
//                let listArtisan = try JSONDecoder().decode([Artisan].self, from: data)
//                self.callBack?(listArtisan, true, "")
//            }catch{
//                self.callBack?(nil, false, error.localizedDescription)
//            }
//        }
//    }
//
//    func getAllServises(_ artisanID: String){
//        AF.request(APIServices.baseURL+"/"+artisanID, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { [self] responseData in
//            guard let data = responseData.data else {
//                self.servicescallBack?(nil, false, "")
//                return}
//            do{
//                let artisan = try JSONDecoder().decode(Artisan.self, from: data)
//                let listService = artisan.services
//                self.servicescallBack?(listService, true, "")
//            }catch{
//                self.servicescallBack?(nil, false, error.localizedDescription)
//            }
//        }
//    }
//
//    func completionHandlerArtisan(callBack: @escaping artisansCallback){
//        self.callBack = callBack
//    }
//    func completionHandlerServices(callBack: @escaping servicesCallback){
//        self.servicescallBack = callBack
//    }
}

extension APIServices: TargetType{
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
