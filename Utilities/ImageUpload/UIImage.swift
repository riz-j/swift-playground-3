//
//  UIImage.swift
//  image-picker
//
//  Created by Rizki Judojono on 6/6/2023.
//

import Foundation
import SwiftUI

/*
 
 This is an extension for UIImage that takes an image and convers it to datatype of "Data" so that
 it can be sent over HTTP POST to upload the image to the cloud.
 
 Moreover, on top of that, this extension compresses the image to be stored in the cloud.
 
 Source: https://stackoverflow.com/questions/29726643/how-to-compress-of-reduce-the-size-of-an-image-before-uploading-to-parse-as-pffi
 
 */

extension UIImage {
    func toData() -> Data? {
        return self.jpegData(compressionQuality: 0.1)
    }
}
