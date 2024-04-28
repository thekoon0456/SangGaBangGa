//
//  DefaultsAnnotation.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/28/24.
//

import MapKit
import UIKit

import Kingfisher

final class DefaultsAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}
