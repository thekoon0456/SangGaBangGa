//
//  PaymentsRequest.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/5/24.
//

import Foundation

struct PaymentsRequest: Encodable {
    let impUID: String
    let postID: String
    let productName: String
    let price: Int
    
    enum CodingKeys: String, CodingKey {
        case impUID = "imp_uid"
        case postID = "post_id"
        case productName
        case price
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.impUID, forKey: .impUID)
        try container.encode(self.postID, forKey: .postID)
        try container.encode(self.productName, forKey: .productName)
        try container.encode(self.price, forKey: .price)
    }
}
