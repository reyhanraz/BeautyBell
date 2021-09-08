//
//  ArtisanReview.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi Azzami on 06/09/21.
//
import Foundation

// MARK: - Welcome
struct Responses: Codable {
    let data: DataClasses
    let status: Status
}

// MARK: - DataClass
struct DataClasses: Codable {
    let artisanReview: ArtisanReview
}

// MARK: - ArtisanReview
struct ArtisanReview: Codable {
    let id, artisanID, customerID: Int
    let comment: String
    let rating: Int
    let updatedAt: String
    let customer: Customer

    enum CodingKeys: String, CodingKey {
        case id
        case artisanID = "artisanId"
        case customerID = "customerId"
        case comment, rating, updatedAt, customer
    }
}

// MARK: - Customer
struct Customer: Codable {
    let id: Int
    let name: String
    let avatarURL: String
    let avatarServingURL: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case avatarURL = "avatarUrl"
        case avatarServingURL = "avatarServingUrl"
    }
}

// MARK: - Status
public struct Status: Codable {
    
    public var status: Status.Detail
    
    public var error: [DataError]?
    
    public var message: String?
    
    public init(status: Status.Detail, errors: [DataError]? = nil) {
        self.status = status
        self.error = errors
    }
    
    public struct Detail: Codable {
        public let code: Int
        public let message: String
        
        public init(code: Int, message: String) {
            self.code = code
            self.message = message
        }
        
        enum CodingKeys: String, CodingKey {
            case code
            case message
        }
    }
}

public struct DataError: Codable {
    public let message: String
    public let parameter: String
    public let value: String?
}
