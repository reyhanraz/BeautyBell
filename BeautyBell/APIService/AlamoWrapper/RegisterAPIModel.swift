//
//  RegisterAPIModel.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi Azzami on 07/09/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
struct RegisterAPIModel: Codable {
    let data: RegisData
    let status: Status.Detail
}

// MARK: - DataClass
struct RegisData: Codable {
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case user
    }
}

class RegisterAPI: AlamoWrapper{
    
    func registerUser(name: String, email: String, password: String, phone: String) -> Observable<RegisterAPIModel>{
        let param = [
            "name" : name,
            "email" : email,
            "password" : password,
            "phone" : phone
        ]
       
        return request(endPoint: "-customerRegister", method: .post, parameter: param, JSONencoding: true)
        
    }
}
