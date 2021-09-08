//
//  LoginAPI.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi Azzami on 06/09/21.
//

import Foundation
import RxSwift

struct LoginAPIModel: Codable {
    public let status: Status.Detail
    public let data: Data
    public let errors: [DataError]?
    
    public struct Data: Codable {
        public let user: User?
        public let token: String?
        
        enum CodingKeys: String, CodingKey {
            case user
            case token
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case data
        case errors = "error"
    }
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let name, email, phone, dob: String?
    let gender, status, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name, email, phone, dob
        case gender, status, createdAt, updatedAt
    }
    
}

class LoginApi: AlamoWrapper{
    func requestLogin(email: String, password: String) -> Observable<LoginAPIModel>{
        let endPoint = "-customerLogin"
        let body = ["email" : email,
                    "password" : password]
        return request(endPoint: endPoint, method: .post, parameter: body, JSONencoding: true)
    }
}
