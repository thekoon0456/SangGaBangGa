//
//  UIImage+.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/20/24.
//

import UIKit

extension UIImage {
    
    func resizedAnnotation() -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: 64, height: 84))
        self.draw(in: CGRect(x: 0, y: 0, width: 64, height: 84))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
