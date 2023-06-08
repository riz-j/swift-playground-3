//
//  SocketController.swift
//  playground-3
//
//  Created by Rizki Judojono on 6/6/2023.
//

import Foundation
import SwiftUI
import SocketIO
import AVKit

final class Service: ObservableObject {
    @Published var PubLanRoom: String = ""
    //@Published var manager: SocketManager?
    
    
    public lazy var manager = SocketManager(socketURL: URL(string: "https://ws.copager.com")!, config: [
            .log(true),
            .compress,
            .connectParams([
                "USER_ID": UserDefaults.standard.string(forKey: "USER_ID") ?? UUID().uuidString,
                "LAN_ROOM": UserDefaults.standard.string(forKey: "PUB_LAN_ROOM") ?? "PUBLIC_LAN__118"
                //"USER_ID": "j23n41-n3j2n1-4jn3j1-23n1j2",
                //"LAN_ROOM": "PUBLIC_LAN__49"
            ])
    ])
     
    
    
    
    @Published var Messages = [Message]()
    @Published var messages = [String]()
    @Published var dataStore = DataStore()
        
    init() {
        
        GetIpAddress() { ip in
            let _PubLanRoom = BuildLanRoom(ipAddr: ip)
            print("IP ADDRESSSSSSSS: \(_PubLanRoom)")

            if let user_id = UserDefaults.standard.string(forKey: "USER_ID") {
            } else {
                UserDefaults.standard.set(UUID().uuidString, forKey: "USER_ID")
            }
            
            UserDefaults.standard.set(_PubLanRoom, forKey: "PUB_LAN_ROOM")
        }
        
        
        let socket = manager.defaultSocket
        
        
        socket.on(clientEvent: .connect) { (data, ack) in
            print("-------------------------")
            print(" Connected to WS server!")
            print("-------------------------")
            socket.emit("on_ping");
            socket.emit("on_request_lan_parcel");
            socket.emit("on_join_lan_room");
        }
        
        
        socket.on("onParcel") { (data, ack) in
            if let rawData = data[0] as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: rawData, options: [])
                    let decoder = JSONDecoder()
                    let dataParcel: DataStore = try decoder.decode(DataStore.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.dataStore = dataParcel
                        
                        print(dataParcel)
                        
                        print("------------- OOOO ---------------")
                        print(self.dataStore.users)
                    }
                } catch {
                    print("Error deserializing data store: \(error)")
                }
            }
        }
        
        
        socket.on("onMessage") { (data, ack) in
            if let rawData = data[0] as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: rawData, options: [])
                    let decoder = JSONDecoder()
                    let message: Message = try decoder.decode(Message.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.dataStore.messages.append(message)
                            
                        print("---------------------------")
                        print(" _id: \(message.id)")
                        print(" Message: \(message.message)")
                        print(" Sender: \(message.sender)")
                        print("---------------------------")
                        }
                } catch {
                    print("Error deserializing message data: \(error)")
                }
            }
        }
        socket.connect()
    }
}
