//
//  Models.swift
//  playground-3
//
//  Created by Rizki Judojono on 9/5/2023.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var type: String
    var message: String
    var timestamp: String

    var sender: String
    var room: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type
        case message
        case timestamp
        case sender
        case room
    }
}

struct IUser {
    var id: String
    var displayName: String
    var displayColor: String
}
