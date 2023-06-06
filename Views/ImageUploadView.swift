//
//  ContentView.swift
//  image-picker
//
//  Created by Rizki Judojono on 6/6/2023.
//

import SwiftUI

struct ImageUploadView: View {
    @ObservedObject var global: Global
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
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
                    Button("Save", action: save)
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
                
                
                print ("Go the URL Bro: \(url)")
                global.currentView = "chat"
            } else {
                print ("Failed to get URL :(")
                global.currentView = "chat"
            }
        }
    }
    

}

