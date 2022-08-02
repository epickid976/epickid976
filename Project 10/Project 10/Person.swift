//
//  Person.swift
//  Project 10
//
//  Created by Jose Blanco on 5/28/22.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
}
