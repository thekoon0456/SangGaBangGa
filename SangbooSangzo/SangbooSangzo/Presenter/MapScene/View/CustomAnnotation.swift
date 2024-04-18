//
//  CustomAnnotation.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import MapKit
import UIKit

final class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D,
         title: String? = nil,
         subtitle: String? = nil,
         image: UIImage? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}
