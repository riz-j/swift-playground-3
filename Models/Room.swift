//
//  Room.swift
//  playground-3
//
//  Created by Rizki Judojono on 8/6/2023.
//

import Foundation

/*
 This is the Room ViewModel containing its CodingKeys.
 */

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
