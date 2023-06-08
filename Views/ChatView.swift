//
//  ChatView.swift
//  playground-3
//
//  Created by Rizki Judojono on 6/6/2023.
//

import Foundation
import SocketIO
import SwiftUI
import AVKit

struct ChatView: View {
    @ObservedObject var global: Global
    //@ObservedObject var service = Service()
    @ObservedObject var service: Service
    private var socket: SocketIOClient { return service.manager.defaultSocket }
    private var roomName: String = "room2"
    @State private var messageInput: String = ""
    //@State var player = AVPlayer(url: URL(string: //"https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!)
    
    init(global: Global, service: Service) {
        self.global = global
        self.service = service
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("LAN Chat")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "info.circle")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            global.currentView = "acknowledgement"
                        }
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
                        
                        
                        HStack {
                            Spacer()
                        }
                        if (msg.type == "text") {
                            let isDifferentSender = prevMsg.map { $0.sender != msg.sender } ?? true
                            if isDifferentSender {
                                
                                Text("\(sender?.displayName ?? "unknown")")
                                    .foregroundColor(Color(hex: "\(sender?.displayColor ?? "#FF0000")"))
                                    .padding(.top, 10)
                                
                            }
                            Text(msg.message)
                                .fixedSize(horizontal: false, vertical: true)
                                .listRowSeparator(.hidden)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 0))
                                .overlay(
                                    Rectangle()
                                        .fill(Color(hex: "\(sender?.displayColor ?? "#FF0000")"))
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
                                            .frame(height: UIScreen.main.bounds.height * 0.2)
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
                                        .fill(Color(hex: "\(sender?.displayColor ?? "#FF0000")"))
                                        .frame(width: 2), alignment: .leading
                                )
                            }
                        }
                        if (msg.type == "video") {
                            //Text(msg.filename)
                            //HStack {
                            VideoPlayer(player: AVPlayer(url:  URL(string: msg.url)!))
                                .frame(height: 205)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 0))
                                .overlay(
                                    Rectangle()
                                        .fill(Color(hex: "\(sender?.displayColor ?? "#FF0000")"))
                                        .frame(width: 2), alignment: .leading
                                )

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
                Button(action: {
                    self.global.currentView = "imagePicker"
                }, label: {
                    Image(systemName: "photo")
                        .font(.title2)
                        
                })

                
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
                        "sender": UserDefaults.standard.string(forKey: "USER_ID")!,
                        "room": UserDefaults.standard.string(forKey: "PUB_LAN_ROOM")!
                    ])
                    
                    messageInput = ""
                    
                }, label: {
                    Image(systemName: "paperplane")
                        .font(.title2)
                        .frame(width: 35)
                })
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
