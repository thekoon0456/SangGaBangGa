//
//  CustomAnnotation.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import MapKit
import UIKit

import Kingfisher

final class SSAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var data: ContentEntity
    
    init(coordinate: CLLocationCoordinate2D,
         data: ContentEntity) {
        self.coordinate = coordinate
        self.data = data
        self.title = data.category
        self.subtitle = data.price
    }
}
