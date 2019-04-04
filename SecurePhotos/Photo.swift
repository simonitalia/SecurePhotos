//
//  Photo.swift
//  SecurePhotos
//
//  Created by Simon Italia on 4/4/19.
//  Copyright © 2019 SDI Group Inc. All rights reserved.
//

import UIKit

//NSObject to write and read from disk
class Photo: NSObject {
    
    var image: UIImage
    var label: String
    
    init(image: UIImage, label: String) {
        self.image = image
        self.label = label
    }
}
