//
//  Users.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 21/06/21.
//

import Foundation

struct Users: Codable {
    var name: String
    var imageURL: String
    var dateOfBirth: String
    var email: String
}
struct UserProfileCache {
    static let key = "userProfileCache"
    static func save(_ value: Users!) {
         UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
    }
    static func get() -> Users! {
        var userData: Users!
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            userData = try? PropertyListDecoder().decode(Users.self, from: data)
            return userData!
        } else {
            return Users(name: "", imageURL: "", dateOfBirth: "", email: "")
        }
    }
    static func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
