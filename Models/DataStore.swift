//
//  DataStore.swift
//  playground-3
//
//  Created by Rizki Judojono on 8/6/2023.
//

import Foundation

/*
 This is the DataStore Model.
 It defines the structure of the DataModel,
 and it initializes the necessary attributes of the model.
 */

struct DataStore: Decodable {
    var currentUser: IUser
    var users: [UserVM]
    var messages: [Message]
    
    init() {
        self.currentUser = IUser(id: "", displayName: "", displayColor: "") // provide a default value
        self.users = [] // empty array
        self.messages = [] // empty array
    }
}
