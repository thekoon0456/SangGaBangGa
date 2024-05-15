//
//  LikeEntity.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/1/24.
//

import Foundation

struct LikeEntity {
    let likeStatus: Bool
    
    static func defaultData() -> LikeEntity {
        LikeEntity(likeStatus: false)
    }
}
