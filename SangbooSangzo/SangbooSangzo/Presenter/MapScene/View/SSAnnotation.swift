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
    var data: UploadContentResponse
    
    init(coordinate: CLLocationCoordinate2D,
         data: UploadContentResponse) {
        self.coordinate = coordinate
        self.data = data
        self.title = data.content1
        self.subtitle = data.content4
    }
}
