//
//  CustomMarkerView.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/5/24.
//

import UIKit
import MapKit

final class CustomMarkerView: MKMarkerAnnotationView {
    
    static var identifier: String {
        return self.description()
    }
    
    init(annotation: (any MKAnnotation)? = nil, reuseIdentifier: String = CustomMarkerView.identifier, color: UIColor = .accent) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.markerTintColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
