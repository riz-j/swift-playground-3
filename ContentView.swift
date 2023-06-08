//
//  ContentView.swift
//  playground-2
//
//  Created by Rizki Judojono on 14/3/2023.
//

import SwiftUI
import SocketIO
import AVKit

/*
 Define a class for a Global object that can be
 observed throughout the app. This class has a published
 state "currentView" that can be observed and manipulated
 throughout the codebase to change the currentView of the user.
 */

class Global: ObservableObject {
    @Published var currentView = "chat"
}

struct ContentView: View {
    @StateObject var global = Global()
    @StateObject var service = Service()

    
    var body: some View {
        if global.currentView == "chat" {
            ChatView(global: global, service: service)
            
        } else if global.currentView == "imagePicker" {
            ImageUploadView(global: global, service: service)
            
        } else if (global.currentView == "acknowledgement") {
            AcknowledgementView(global: global)
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

