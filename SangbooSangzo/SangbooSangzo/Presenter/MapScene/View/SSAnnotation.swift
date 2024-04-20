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
    var image: UIImage?
    var data: UploadContentResponse?
    let imageView = UIImageView()
    
    init(coordinate: CLLocationCoordinate2D,
         data: UploadContentResponse?) {
        self.coordinate = coordinate
        self.data = data
        self.title = data?.title
        self.subtitle = data?.content4
        imageView.kf.setSeSACImage(input: APIKey.baseURL + "/v1/" + (data?.files?.first ?? ""))
        self.image = imageView.image
    }
}
