//
//  ContentView.swift
//  playground-2
//
//  Created by Rizki Judojono on 14/3/2023.
//

import SwiftUI
import SocketIO
import AVKit

class Global: ObservableObject {
    @Published var currentView = "chat"
}

struct ContentView: View {
    @StateObject var global = Global()
    
    var body: some View {
        if global.currentView == "chat" {
            ChatView(global: global)
        } else if global.currentView == "imagePicker" {
            ImageUploadView(global: global)
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

