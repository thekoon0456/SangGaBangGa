//
//  FetchfPostsResponse.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

struct ReadPostsResponse: Decodable {
    let data: [UploadContentResponse]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([UploadContentResponse].self, forKey: .data)
        self.nextCursor = try container.decode(String.self, forKey: .nextCursor)
    }
}
