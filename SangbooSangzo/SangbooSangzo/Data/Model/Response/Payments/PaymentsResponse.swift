//
//  PaymentsResponse.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/5/24.
//

import Foundation

struct PaymentsResponse: Decodable {
    let data: [PaymentsDataResponse]
}

struct PaymentsDataResponse: Decodable {
    let paymentID: String
    let buyerID: String
    let postID: String
    let merchantUID: String
    let productName: String
    let price: Int
    let paidAt: String
    
    enum CodingKeys: String, CodingKey {
        case paymentID = "payment_id"
        case buyerID = "buyer_id"
        case postID = "post_id"
        case merchantUID = "merchant_uid"
        case productName
        case price
        case paidAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.paymentID = try container.decode(String.self, forKey: .paymentID)
        self.buyerID = try container.decode(String.self, forKey: .buyerID)
        self.postID = try container.decode(String.self, forKey: .postID)
        self.merchantUID = try container.decode(String.self, forKey: .merchantUID)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.price = try container.decode(Int.self, forKey: .price)
        self.paidAt = try container.decode(String.self, forKey: .paidAt)
    }
}
