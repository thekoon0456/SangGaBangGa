//
//  UploadContentQuery.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/12/24.
//

import Foundation

struct UploadContentRequest: Encodable {
    let title: String?
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let productID: String?
    let files: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case content1
        case content2
        case content3
        case content4
        case content5
        case productID = "product_id"
        case files
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.content, forKey: .content)
        try container.encodeIfPresent(self.content1, forKey: .content1)
        try container.encodeIfPresent(self.content2, forKey: .content2)
        try container.encodeIfPresent(self.content3, forKey: .content3)
        try container.encodeIfPresent(self.content4, forKey: .content4)
        try container.encodeIfPresent(self.content5, forKey: .content5)
        try container.encodeIfPresent(self.productID, forKey: .productID)
        try container.encodeIfPresent(self.files, forKey: .files)
    }
}
