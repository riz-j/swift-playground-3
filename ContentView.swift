//
//  ContentView.swift
//  playground-2
//
//  Created by Rizki Judojono on 14/3/2023.
//

import SwiftUI
import SocketIO
import AVKit


final class Service: ObservableObject {
    
    public lazy var manager = SocketManager(socketURL: URL(string: "ws://170.64.176.135:8088")!, config: [
            .log(true),
            .compress,
            .connectParams([
                "USER_ID": UserDefaults.standard.string(forKey: "USER_ID")!,
                "LAN_ROOM": UserDefaults.standard.string(forKey: "PUB_LAN_ROOM")!
            ])
    ])
    
    @Published var Messages = [Message]()
    @Published var messages = [String]()
    @Published var dataStore = DataStore()
        
    init() {
        if let user_id = UserDefaults.standard.string(forKey: "USER_ID") {
        } else {
            UserDefaults.standard.set(UUID().uuidString, forKey: "USER_ID")
        }
        UserDefaults.standard.set("PUBLIC_LAN__118_MONASHUNI-AU-AS-AP_AU", forKey: "PUB_LAN_ROOM")
        
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
        
        
        /*
        socket.on(clientEvent: .connect) { (data, ack) in
            print("Connected!")
            socket.emit("my_event", "Hey this is iPhone! Nanana!")
            
            socket.emit("join", ["room": "room2"])
        }
        
        socket.on("my_response") { [weak self] (data, ack) in
            if let data = data[0] as? [String: String],
               let rawMessage = data["response"] {
                DispatchQueue.main.async {
                    self?.messages.append(rawMessage)
                }
            }
        }
         */
        socket.connect()
    }
}


struct ContentView: View {
    @ObservedObject var service = Service()
    private var socket: SocketIOClient { return service.manager.defaultSocket }
    private var roomName: String = "room2"
    @State private var messageInput: String = ""
    @State var player = AVPlayer(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!)
    
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("LAN Chat")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
            }
            .frame(height: 50)
            .background(Color.white)
            .overlay(
                Rectangle()
                    .fill(Color.gray .opacity(0.2))
                    .frame(height: 1), alignment: .bottom
            )
                        
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Iterate over the messages object
                    ForEach(service.dataStore.messages.indices, id: \.self) { index in
                        let prevMsg = index > 0 ? service.dataStore.messages[index-1] : nil
                        let msg = service.dataStore.messages[index]
                        let sender = service.dataStore.users.first(where: {$0.id == msg.sender})
                        //let rawDisplayColor = sender?.displayColor ?? "ef4444"
                        //let hexDisplayColor = rawDisplayColor.replaceOccurrences(of: "#", with: "")

                        
                        //if let sender = service.dataStore.users.first(where: { $0.id == msg.id }) {
                        //    let isDifferentSender = prevMsg.map { $0.sender != msg.sender } ?? true
                       //     if isDifferentSender {
                        //sender != nil ? Text("\(sender!.displayName)") : Text("SMT")
                        //    }
                        //}
                        
                        
                        HStack {
                            Spacer()
                        }
                        if (msg.type == "text") {
                            //Text(sender?.displayName ?? "unknown")
                            let isDifferentSender = prevMsg.map { $0.sender != msg.sender } ?? true
                            if isDifferentSender {
                                
                                Text("\(sender?.displayName ?? "unknown")")
                                    .foregroundColor(Color.pink)
                                    .padding(.top, 10)
                            }
                            Text(msg.message)
                                .fixedSize(horizontal: false, vertical: true)
                                .listRowSeparator(.hidden)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 0))
                                .overlay(
                                    Rectangle()
                                        .fill(Color.pink)
                                        .frame(width: 2), alignment: .leading
                                )
                                .swipeActions {
                                    Button(action: {
                                        print("Nooice")
                                    }, label: {
                                        Text("")
                                    })
                                }
                        }
                        if (msg.type == "user_join_notice") {
                            Text(msg.message)
                                .font(.callout)
                                .fixedSize(horizontal: false, vertical: true)
                                .listRowSeparator(.hidden)
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                .foregroundColor(Color.gray)
                            
                        }
                        if (msg.type == "image") {
                            HStack {
                                AsyncImage(url: URL(string: msg.url)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: UIScreen.main.bounds.height * 0.4)
                                    case .empty:
                                        Text("Loading Image...")
                                    case .failure(_):
                                        Text("Image fetch failed")
                                    @unknown default:
                                        Text("No Image")
                                    }
                                }
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 0))
                                .overlay(
                                    Rectangle()
                                        .fill(Color.pink)
                                        .frame(width: 2), alignment: .leading
                                )
                            }
                        }
                        if (msg.type == "file") {
                            Text(msg.filename)
                            //HStack {
                            VideoPlayer(player: AVPlayer(url:  URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!))
                                .frame(height: 400)

                            //        }
                                //.padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 0))
                                //.overlay(
                                // Rectangle()
                                //        .fill(Color.pink)
                                //       .frame(width: 2), alignment: .leading
                                //)
                            
                        }
                    }
                }
                .padding(10)
            }
            
            
            HStack {
                TextField("Send Message", text: $messageInput)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .frame(height: 45)
                    .background(Color.gray .opacity(0.15))
                    .cornerRadius(.infinity)
                    
                Button(action: {
                    let uuid = UUID().uuidString
                    
                    let dateFormatter = ISO8601DateFormatter()
                    let dateNow = Date()
                    let isoDateString = dateFormatter.string(from: dateNow)
                    
                    socket.emit("on_message", [
                        "_id": uuid,
                        "type": "text",
                        "message": messageInput,
                        "timestamp": isoDateString,
                        "sender": "j23n41-n3j2n1-4jn3j1-23n1j2",
                        "room": "PUBLIC_LAN__118_MONASHUNI-AU-AS-AP_AU"
                    ])
                    
                    messageInput = ""
                    
                }, label: {
                    Image(systemName: "paperplane")
                        .font(.title2)
                        .frame(width: 35)
                })
                
                //Button("Send ") {
                //    socket.emit("room_event", ["data": messageInput, "room": roomName])
                //}
            }
            .padding()
            .background(Color.white)
            .overlay(
                Rectangle()
                    .fill(Color.gray .opacity(0.2))
                    .frame(height: 1), alignment: .top
            )
            
            //Spacer()
        }
        .background(Color.white)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

