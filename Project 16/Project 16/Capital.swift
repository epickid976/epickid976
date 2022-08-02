//
//  Capital.swift
//  Project 16
//
//  Created by Jose Blanco on 6/15/22.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var webpage: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, webpage: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.webpage = webpage
    }
}
