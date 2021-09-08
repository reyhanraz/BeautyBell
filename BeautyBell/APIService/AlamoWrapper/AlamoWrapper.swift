//
//  AlamoWrapper.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi Azzami on 06/09/21.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
    case loginInvalid
}

extension ApiError: LocalizedError{
    public var errorDescription: String? {
        switch self {
            case .forbidden:
                return "Forbidden"
            case .notFound:
                return "NOT FOUND"
            case .conflict:
                return "Confilct"
            case .internalServerError:
                return "internalServerError"
            case .loginInvalid:
                return "Login Invalid"
        }
    }
}

class AlamoWrapper : NSObject{
    
    let failedProperty = PublishSubject<[DataError]>()
    public let failed: Driver<[DataError]>

    override init() {
        failed = failedProperty.asDriver(onErrorDriveWith: .empty())

        super.init()

    }
    
    public static var url :String = "https://asia-southeast2-beautybell-dashboard.cloudfunctions.net/beautybell-stg"
    
    public static var modelIdentifier: String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    public static let defaultHttpHeaders = [
        "Content-Type": "application/json",
        "Platform": "iOS",
        "Language": "config.country".l10n(),
        "Build-Version":  "",
        "Build-Number":  "",
        "Device": "\(ProcessInfo().operatingSystemVersion.majorVersion).\(ProcessInfo().operatingSystemVersion.minorVersion)",
        "Device-Name": UIDevice.current.name,
        "Model": modelIdentifier,
        "Scope": "customer"
    ]
    
    public static var httpHeaders: [String : String] {
         // Generate random header
            let random = UUID().uuidString
            
        let salt = MD5(string: "\(random)\(AlamoWrapper.defaultHttpHeaders["Build-Version"]!)\(AlamoWrapper.defaultHttpHeaders["Build-Number"]!)\(AlamoWrapper.defaultHttpHeaders["Device"]!)\(AlamoWrapper.defaultHttpHeaders["Model"]!)").base64EncodedString()
        
        return AlamoWrapper.defaultHttpHeaders.merging(["Signature": salt, "token": random], uniquingKeysWith: { (first, _) in first })
        
    }
    enum Method: String {
        case connect
        case delete
        case get
        case head
        case options
        case patch
        case post
        case put
        case trace
        
        func getMethod() -> HTTPMethod{
            switch self{
            case .connect:
                return .connect
            case .delete:
                return .delete
            case .get:
                return .get
            case .head:
                return .head
            case .options:
                return  .options
            case .patch:
                return  .patch
            case .post:
                return  .post
            case .put:
                return .put
            case .trace:
                return .trace
            }
        }
    }
    
    
    func request<T: Codable>(endPoint: String, method: Method, parameter: Parameters, JSONencoding: Bool = false) -> Observable<T>{
        var encoding : ParameterEncoding = URLEncoding.default
        if JSONencoding{
            encoding = JSONEncoding.default
        }
        return Observable<T>.create { observer in
            AF.request(AlamoWrapper.url+endPoint,method: method.getMethod(), parameters: parameter, encoding: encoding, headers: HTTPHeaders(AlamoWrapper.httpHeaders)).responseJSON { response in
                        switch response.result {
                        case .success(_):
                            do {
                                let data = try JSONDecoder().decode(T.self, from: response.data!)
                                print(response.value)
                                print(data)
                                observer.onNext(data)
                                observer.onCompleted()
                            } catch _ {
                                do {
                                    print(response.value)
                                    let data = try JSONDecoder().decode(Status.self, from: response.data!)
                                    print(data.error)
                                    self.failedProperty.onNext(data.error!)
                                } catch let error {
                                    print(error)
                                    print(response.value)
                                    observer.onError(ApiError.loginInvalid)
                                }
                                observer.onError(ApiError.loginInvalid)
                            }
                        case .failure(let error):
                            print(error)
                            print(error.localizedDescription)
                            switch response.response?.statusCode {
                            case 403:
                                observer.onError(ApiError.forbidden)
                            case 404:
                                observer.onError(ApiError.notFound)
                            case 409:
                                observer.onError(ApiError.conflict)
                            case 500:
                                observer.onError(ApiError.internalServerError)
                            default:
                                observer.onError(error)
                            }
                        }
                    }
            
                    return Disposables.create()
                }
        
//        return Observable.create {[weak self] observer in
//            guard let strongSelf = self else{
//                return Disposables.create()}
//            AF.request(AlamoWrapper.url + endPoint, method: method.getMethod(), parameters: parameter, encoding: encoding, headers: HTTPHeaders(strongSelf.httpHeaders) ).responseData(completionHandler: {response in
//                switch response.result{
//                    case .success(let res):
//                        if let code = response.response?.statusCode{
//                            switch code {
//                                case 200...299:
//                                    do {
//                                        let returned = try JSONDecoder().decode(type, from: res)
//                                        print(returned)
//                                        observer.onNext(returned)
//                                    } catch let error {
//                                        print(String(data: res, encoding: .utf8) ?? "nothing received")
//                                        observer.onError(error)
//                                    }
//                                default:
//                                    let error = NSError(domain: response.debugDescription, code: code, userInfo: response.response?.allHeaderFields as? [String: Any])
//                                    print(error.localizedDescription)
//                                    observer.onError(error)
//                                }
//                        }
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                        observer.onError(error)
//                    }
//                })
//            return Disposables.create()
//        }
    }
}
