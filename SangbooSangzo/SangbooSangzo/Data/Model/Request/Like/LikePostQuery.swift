//
//  LikePostQuery.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

struct LikePostQuery: Encodable {
    let next: String?
    let limit: String?
    
    enum CodingKeys: CodingKey {
        case next
        case limit
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.next, forKey: .next)
        try container.encodeIfPresent(self.limit, forKey: .limit)
    }
}
