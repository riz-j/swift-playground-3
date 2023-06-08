//
//  AcknowledgementView.swift
//  playground-3
//
//  Created by Rizki Judojono on 8/6/2023.
//

import SwiftUI

struct AcknowledgementView: View {
    @ObservedObject var global: Global
    
    var body: some View {

            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Acknowledgement")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("")
                        Text("The foundations of this app was built by the hard work of so many people that contribute to the open source community. Together, they make up the backbone of the software world, and this app would not have been possible without the generous contributions of open-source software developers.\n")
                        Text("First and foremost, I would like to express my immense gratitude to Miguel Grinberg, who 'til this day manages the python-socketio library. His kindness and hard work made building websocket servers in python a breeze.\n\nSpecial thanks to Paul Hudson from Hacking With Swift for providing invaluable learning materials for SwiftUI. SwiftUI is a new technology released by Apple and Paul Hudson's Hacking With Swift has been a haven for thousands of SwiftUI developers like me.\n")
                        Text("I would also like to express my appreciation to Erik Little and all the contributors of socket.io-swift-client. Without this wonderful repository, building a socket.io client in SwiftUI would be impossible.\n\nI would like to thank the hundreds of FastAPI contributors for creating the simplest REST API framework for Python. Because of this library, this app is able to process file uploads in the cloud easily.\n")
                        Text("Finally, I would like to thank the team at ipify.org and jsonip.com for creating an API that details a client's IP address, and for facilitating the API at no cost. This project and many other projects all around the world would not have been possible without their generosity.\n")
                        Text("Thank you all.\n")
                        
                        Text("Resources and Licenses")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("socketio/socket.io-client-swift --- MIT License (No restriction)\nmiguelgrinberg/python-socketio --- MIT License (No restriction)\ntiangolo/fastapi --- MIT License (No restriction)")

                    
                    }
                }
                Spacer()
                
                Button(action: {
                    global.currentView = "chat"
                }, label: {
                    Text("Go back")
                })
            }
            .padding()
        
    }
}
