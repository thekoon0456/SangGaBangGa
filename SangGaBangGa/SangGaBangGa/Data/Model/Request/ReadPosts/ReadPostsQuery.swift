//
//  FetchPostRequest.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

struct ReadPostsQuery: Encodable {
    let next: String?
    let limit: String?
    let productID: String?
    let hashTag: String?
    
    enum CodingKeys: String, CodingKey {
        case next
        case limit
        case productID = "product_id"
        case hashTag
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.next, forKey: .next)
        try container.encodeIfPresent(self.limit, forKey: .limit)
        try container.encodeIfPresent(self.productID, forKey: .productID)
        try container.encodeIfPresent(self.hashTag, forKey: .hashTag)
    }
}

