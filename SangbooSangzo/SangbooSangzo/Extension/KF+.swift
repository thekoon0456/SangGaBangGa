//
//  KF+.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/19/24.
//

import UIKit

import Kingfisher

extension KingfisherWrapper<UIImageView> {
    
    func setSeSACImage(input: String) {
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 300, height: 300), mode: .aspectFill)
        
        let url = URL(string: input)
        
        let modifier = AnyModifier { request in
            var request = request
            request.setValue(UserDefaultsManager.shared.userData.accessToken ?? "",
                             forHTTPHeaderField: HTTPHeader.authorization)
            request.setValue(APIKey.sesacKey, forHTTPHeaderField: HTTPHeader.sesacKey)
            return request
        }

        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
                 .transition(.fade(1)),
                 .cacheOriginalImage,
            .requestModifier(modifier)
        ]
        self.setImage(with: url, options: options)
//        return (with: url, options: options)
    }
}
