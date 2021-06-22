//
//  Service.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 21/06/21.
//

import Foundation
import Alamofire

class APIServices {
    //https://604048b4f34cf600173c7cda.mockapi.io/api/v1/list-artisan
    fileprivate var baseURL = ""
    typealias artisansCallback = (_ artisans:[Artisan]?, _ status: Bool, _ message: String) -> Void
    var callBack: artisansCallback?
    typealias servicesCallback = (_ services:[Service]?, _ status: Bool, _ message: String) -> Void
    var servicescallBack: servicesCallback?
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func getAllArtisan(){
        AF.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { responseData in
            guard let data = responseData.data else {
                self.callBack?(nil, false, "")
                return}
            do{
                let listArtisan = try JSONDecoder().decode([Artisan].self, from: data)
                self.callBack?(listArtisan, true, "")
            }catch{
                self.callBack?(nil, false, error.localizedDescription)
            }
        }
    }
    
    func getAllServises(_ artisanID: String){
        AF.request(baseURL+"/"+artisanID, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { [self] responseData in
            guard let data = responseData.data else {
                self.servicescallBack?(nil, false, "")
                return}
            do{
                let artisan = try JSONDecoder().decode(Artisan.self, from: data)
                let listService = artisan.services
                self.servicescallBack?(listService, true, "")
            }catch{
                self.servicescallBack?(nil, false, error.localizedDescription)
            }
        }
    }
    
    func completionHandlerArtisan(callBack: @escaping artisansCallback){
        self.callBack = callBack
    }
    func completionHandlerServices(callBack: @escaping servicesCallback){
        self.servicescallBack = callBack
    }
}
