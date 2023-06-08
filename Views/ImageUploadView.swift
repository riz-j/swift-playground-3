//
//  ContentView.swift
//  image-picker
//
//  Created by Rizki Judojono on 6/6/2023.
//

import SwiftUI
import SocketIO

/*
 
 This is the ImageUploadView. User can select and image, upload it to the cloud,
 and send the URL string as a reference to the image.
 
 Source: https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-phpickerviewcontroller
 
 */

struct ImageUploadView: View {
    @ObservedObject var global: Global
    @ObservedObject var service: Service
    private var socket: SocketIOClient { return service.manager.defaultSocket }
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.white)
                    
                    VStack {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        HStack {
                            Image(systemName: "hand.tap.fill")
                                .foregroundColor(.black)
                            Text("Tap to select a picture")
                                .foregroundColor(.black)
                                .font(.headline)
                        }
                    }
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    // select an image
                    showingImagePicker = true
                }
                
                HStack {
                    Button("Cancel", action: {
                        self.global.currentView = "chat"
                    })
                    Spacer()
                    Button("Send", action: save)
                }
            }
        }
        .padding([.horizontal, .vertical])
        .navigationTitle("Image Stuff")
        .onChange(of: inputImage) { _ in loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        
        print("Image loaded")
    }
    
    func save() {
        guard let inputImage = inputImage else {
            
            print("There is no inputImage!")
            return
        }
        
        // Make POST request to the FastAPI "/upload" endpoint
        uploadImage(image: inputImage) { url in
            if let url = url {
                // URL acquired. Now perform action:
                
                let uuid = UUID().uuidString
                
                let dateFormatter = ISO8601DateFormatter()
                let dateNow = Date()
                let isoDateString = dateFormatter.string(from: dateNow)
                
                socket.emit("on_message", [
                    "_id": uuid,
                    "type": "image",
                    "message": "",
                    "url": url,
                    "timestamp": isoDateString,
                    "sender": UserDefaults.standard.string(forKey: "USER_ID")!,
                    "room": UserDefaults.standard.string(forKey: "PUB_LAN_ROOM")!,
                    "filename": uuid
                ])
                
                print ("Go the URL Bro: \(url)")
                global.currentView = "chat"
            } else {
                print ("Failed to get URL :(")
                global.currentView = "chat"
            }
        }
    }
    

}

