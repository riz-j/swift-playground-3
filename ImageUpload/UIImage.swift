//
//  UIImage.swift
//  image-picker
//
//  Created by Rizki Judojono on 6/6/2023.
//

import Foundation
import SwiftUI

extension UIImage {
    func toData() -> Data? {
        return self.jpegData(compressionQuality: 0.1)
    }
}
