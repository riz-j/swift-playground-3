//
//  UploadImage.swift
//  image-picker
//
//  Created by Rizki Judojono on 6/6/2023.
//

import Foundation
import SwiftUI

/*
 
 This function takes a UIImage and returns a completion.
 The function makes a POST request to the file bucket endpoint.
 Once the image is successfully uploaded, the file bucket API will
 return the URL string of the file. That URL string will be returned
 by the function if the completion is fulfilled. If the completion
 is rejected, nil will be returned.
 
 Source: https://sebastianroy.de/sending-an-image-as-post-request-with-swift-5-to-go-119-server/
 
 */

func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
    // "https://files.copager.com/upload"
    guard let imageData = image.toData() else { return }
        let urlString = "https://files.copager.com/upload"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        let fileName = "file.jpg"
        
        /*
         Append to the data object the headers for the file bucket to understand
         */
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ImageUploaderAPIResponse.self, from: data)
                    print("Message: \(response.message)")
                    print("URL: \(response.URL)")
                    completion(response.URL)
                } catch {
                    print("Error decoding reponse: \(error)")
                    completion(nil)
                }
            }
        }
        
        task.resume()
}

struct ImageUploaderAPIResponse: Codable {
    let message: String
    let URL: String
}
