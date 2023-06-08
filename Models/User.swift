//
//  User.swift
//  playground-3
//
//  Created by Rizki Judojono on 8/6/2023.
//

import Foundation

/*
 These are the models for User with its CodingKeys.
 IUser is a superset of UserVM
 */

struct IUser: Identifiable, Codable {
    var id: String
    var displayName: String
    var displayColor: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case displayName
        case displayColor
    }
}

struct UserVM: Identifiable, Codable {
    var id: String
    var displayName: String
    var profilePic: String?
    var profileStatus: String?
    var displayColor: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case displayName
        case profilePic
        case profileStatus
        case displayColor
    }
}
