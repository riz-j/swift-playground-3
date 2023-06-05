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
    var filename: String
    var url: String
    var timestamp: String

    var sender: String
    var room: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type
        case message
        case filename
        case url
        case timestamp
        case sender
        case room
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            type = try container.decode(String.self, forKey: .type)
            message = try container.decode(String.self, forKey: .message)
            filename = try container.decodeIfPresent(String.self, forKey: .filename) ?? ""
            url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
            timestamp = try container.decode(String.self, forKey: .timestamp)
            sender = try container.decode(String.self, forKey: .sender)
            room = try container.decode(String.self, forKey: .room)
        }
}

struct DataStore: Decodable {
    var currentUser: IUser
    // var rooms: [RoomVM]
    var users: [UserVM]
    var messages: [Message]
    
    init() {
        self.currentUser = IUser(id: "", displayName: "", displayColor: "") // provide a default value
        // self.rooms = [] // empty array
        self.users = [] // empty array
        self.messages = [] // empty array
    }
}

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

struct RoomVM: Identifiable, Codable {
    var id: String
    var type: String
    var name: String
    var displayPicture: String?
    
    var messages: [String]
    var users: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type
        case name
        case displayPicture
        case messages
        case users
    }
}
