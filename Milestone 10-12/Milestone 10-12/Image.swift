//
//  Image.swift
//  Milestone 10-12
//
//  Created by Jose Blanco on 6/4/22.
//

import UIKit

class Image: Codable {
    var image: String
    var caption: String
    
    init(image: String, caption: String) {
        self.image = image
        self.caption = caption
    }
}
