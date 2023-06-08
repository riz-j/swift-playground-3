//
//  Message.swift
//  playground-3
//
//  Created by Rizki Judojono on 8/6/2023.
//

import Foundation

/*
 This is the Message Model.
 It defines the structure of the Message,
 its coding keys and its constructor that decodes JSON
 */

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
