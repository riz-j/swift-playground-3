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

/*
 
 This is the Service Observable Object that will be kept alive and its state will be preserved
 as long as the app is running. This object is responsible for establishing a handshake with the
 WebSocket server, receiving messages from the WebSocket server, and emitting events to the server.
 
 Source: https://github.com/socketio/socket.io-client-swift
 
 */

final class Service: ObservableObject {
    @Published var PubLanRoom: String = ""
    
    /* Establish connection to the Websocket server and assign the connection object to the "manager" object. */
    public lazy var manager = SocketManager(socketURL: URL(string: "https://ws.copager.com")!, config: [
            .log(true),
            .compress,
            .connectParams([
                "USER_ID": UserDefaults.standard.string(forKey: "USER_ID") ?? UUID().uuidString,
                "LAN_ROOM": UserDefaults.standard.string(forKey: "PUB_LAN_ROOM") ?? "PUBLIC_LAN__118"
            ])
    ])
    
    /* Define the states that will be observed by the UI components accross the app. */
    @Published var Messages = [Message]()
    @Published var messages = [String]()
    @Published var dataStore = DataStore()
        
    init() {
        /* Get the IP address of the client and build the LAN room string for the server */
        GetIpAddress() { ip in
            let _PubLanRoom = BuildLanRoom(ipAddr: ip)
            print("IP ADDRESSSSSSSS: \(_PubLanRoom)")
            
            /* Persist the client ID and connection string to UserDefaults */
            if let user_id = UserDefaults.standard.string(forKey: "USER_ID") {
            } else {
                UserDefaults.standard.set(UUID().uuidString, forKey: "USER_ID")
            }
            
            UserDefaults.standard.set(_PubLanRoom, forKey: "PUB_LAN_ROOM")
        }
        
        /* Define "socket" object for emitting and receiving events from the WebSocket server. */
        let socket = manager.defaultSocket
        
        /* This code runs when connection with the WebSocket server has been established. */
        socket.on(clientEvent: .connect) { (data, ack) in
            print("-------------------------")
            print(" Connected to WS server!")
            print("-------------------------")
            socket.emit("on_ping");
            socket.emit("on_request_lan_parcel");
            socket.emit("on_join_lan_room");
        }
        
        /* This code runs when a parcel is delivered from the WebSocket server. */
        socket.on("onParcel") { (data, ack) in
            if let rawData = data[0] as? [String: Any] {
                do {
                    /* Decode the parcel and store it in the state objects. */
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
        
        /* This code handles messages that are sent from the WebSocket server. */
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
        
        /* Finally, connect to the WebSocket server. */
        socket.connect()
    }
}
